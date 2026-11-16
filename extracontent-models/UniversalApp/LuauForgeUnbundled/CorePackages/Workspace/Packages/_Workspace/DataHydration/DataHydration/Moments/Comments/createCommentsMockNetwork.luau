local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local isCanonicalNonzeroUuid = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/isCanonicalNonzeroUuid")
local CommentFixtures = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Comments/CommentFixtures")
local MockCommentsPages = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Comments/MockCommentsPages")

local function parseQuery(url)
	local query = {}
	local v5 = string.find(url, "?", 1, true)

	if v5 == nil then
		return query
	end

	for k in string.gmatch(string.sub(url, v5 + 1), "[^&]+") do
		local v6, v7 = string.match(k, "([^=]+)=?(.*)")

		if v6 ~= nil then
			query[v6] = v7 or ""
		end
	end

	return query
end

local function feedItemIdFromCommentsUrl(value)
	return string.match(value, "/moments/([^/]+)/comments") or "feed-1"
end

local function commentIdFromDeleteUrl(value)
	return string.match(value, "/comments/([^/?]+)$")
end

local function reactionIdsFromUrl(value)
	return string.match(value, "/moments/([^/]+)/comments/([^/]+)/reactions$")
end

local function commentKey(p2, p3)
	return `{p2}:{p3}`
end

local function decodeBody(body)
	if type(body) ~= "string" or body == "" then
		return {}
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, body)

	if success then
		return result
	end

	return {}
end

local function json(p2, p3, p4)
	local v6 = if p3 ~= nil then HttpService:JSONEncode(p3) else nil
	return { statusCode = p2, headers = p4, responseBody = v6 }
end

local function toApiComment(data)
	local apiComment = {
		commentId = data.commentId,
		feedItemId = data.feedItemId,
		authorUserId = 0,
		text = 0,
		translatedText = 0,
		createdAt = 0,
		isAuthoredByViewer = 0,
		reactions = 0
	}
	local v5 = if data.author ~= nil then data.author.userId else nil
	apiComment.authorUserId = v5
	apiComment.text = data.text
	apiComment.translatedText = data.translatedText
	apiComment.createdAt = data.createdAt
	apiComment.isAuthoredByViewer = data.isAuthoredByViewer
	apiComment.reactions = data.reactions
	return apiComment
end

local function cloneReactions(p2)
	local clones = table.create(#p2.counts)

	for k, count in p2.counts do
		table.insert(clones, table.clone(count))
	end

	local v5 = if p2.userReaction ~= nil then table.clone(p2.userReaction) else nil
	return { counts = clones, userReaction = v5 }
end

local function scheduleDelay(duration, callback)
	local thread = task.delay(duration, callback)
	return function()
		if coroutine.status(thread) == "suspended" then
			task.cancel(thread)
		end
	end
end

local function createCommentsMockNetwork(options)
	local unixTimestamp = DateTime.now().UnixTimestamp

	local set = {}
	local v5 = {}

	local function indexVisibleComment(p2)
		local v6 = v5[p2.feedItemId]

		if v6 == nil then
			v6 = {}
			v5[p2.feedItemId] = v6
		end

		v6[p2.commentId] = p2
	end

	local function visibleComment(p2, p3)
		local v6 = v5[p2]

		if v6 == nil or set[`{p2}:{p3}`] then
			return nil
		end

		return v6[p3]
	end

	local v6 = {}

	local reactions = {}
	local v7 = options or {}

	local comments = {}

	for k, v8 in { CommentFixtures.REACTION_IDS.feedItemId, CommentFixtures.REACTION_IDS.otherFeedItemId } do
		for k2, comment in MockCommentsPages.reactionPage(v8, unixTimestamp).comments do
			local commentsByCommentId = v5[comment.feedItemId]

			if commentsByCommentId == nil then
				commentsByCommentId = {}
				v5[comment.feedItemId] = commentsByCommentId
			end

			commentsByCommentId[comment.commentId] = comment
		end
	end

	local function findComment(p2, p3)
		if set[`{p2}:{p3}`] then
			return nil
		end

		local v8 = v5[p2]
		local v9 = if not (v8 == nil or set[`{p2}:{p3}`]) then v8[p3] else nil

		if v9 ~= nil then
			return v9
		end

		for k, v10 in { "", MockCommentsPages.EMPTY_HAS_MORE_CURSOR, MockCommentsPages.PAGE_3_CURSOR } do
			for k2, comment in MockCommentsPages.pageForCursor(p2, v10, unixTimestamp).comments do
				if comment.commentId == p3 then
					return comment
				end
			end
		end

		return nil
	end

	local function pageWithMutations(p2, cursor, data)
		local v8 = {}

		if cursor == nil or cursor == "" then
			local v9 = v6[p2]

			if v9 ~= nil then
				for k, v10 in v9 do
					if not set[`{v10.feedItemId}:{v10.commentId}`] then
						table.insert(v8, v10)
					end
				end
			end
		end

		for k, comment in data.comments do
			if not set[`{comment.feedItemId}:{comment.commentId}`] then
				table.insert(v8, comment)
			end
		end

		local v9 = {}

		for k, v10 in v8 do
			local v11 = v5[v10.feedItemId]

			if v11 == nil then
				v11 = {}
				v5[v10.feedItemId] = v11
			end

			v11[v10.commentId] = v10

			local v12 = toApiComment(v10)
			local v13 = reactions[`{v10.feedItemId}:{v10.commentId}`]
				or (v7.reactionProjectionsByCommentId or {})[v10.commentId]

			if v13 ~= nil then
				v12.reactions = cloneReactions(v13)
			end

			table.insert(v9, v12)
		end

		return { comments = v9, nextCursor = data.nextCursor, hasMore = data.hasMore }
	end

	local mockNetwork = HttpClient.createMockNetwork({
		routes = {
			{
				pattern = "/reactions",
				respond = function(data)
					local url = data.url
					local v8, v9 = string.match(url, "/moments/([^/]+)/comments/([^/]+)/reactions$")

					local v10 = decodeBody(data.body)

					if
						v8 == nil
						or v9 == nil
						or not isCanonicalNonzeroUuid(v8)
						or not isCanonicalNonzeroUuid(v9)
						or v10.reactionType ~= "thumbsup"
						or not isCanonicalNonzeroUuid(v10.emoteId)
					then
						local v11 = {
							errorCode = "InvalidRequest",
							message = "invalid reaction request"
						}
						local v13 = if v11 ~= nil then HttpService:JSONEncode(v11) else nil
						return { statusCode = 400, headers = nil, responseBody = v13 }
					else
						local v11 = v5[v8]
						local v12 = if not (v11 == nil or set[`{v8}:{v9}`]) then v11[v9] else nil

						if v12 == nil then
							local v13 = {
								errorCode = "CommentNotFound",
								message = "comment was not found for the requested moment"
							}
							local v15 = if v13 ~= nil then HttpService:JSONEncode(v13) else nil
							return {
								statusCode = 404,
								headers = nil,
								responseBody = v15
							}
						else
							local reactionOutcome = v7.reactionOutcome or "success"

							if reactionOutcome == "timeout" then
								error("createCommentsMockNetwork: simulated reaction timeout")
							end

							if reactionOutcome == "ViewerNotEligibleToReact" then
								local viewerNotEligibleToReact = CommentFixtures.ERRORS.ViewerNotEligibleToReact
								local v14 = if viewerNotEligibleToReact ~= nil then HttpService:JSONEncode(viewerNotEligibleToReact) else nil
								return {
									statusCode = 403,
									headers = nil,
									responseBody = v14
								}
							elseif reactionOutcome == "RateLimited" then
								local rateLimited = CommentFixtures.ERRORS.RateLimited
								local v13 = {
									statusCode = 429,
									headers = {
										["retry-after"] = v7.reactionRetryAfter or "10"
									},
									responseBody = 0
								}
								local v14 = if rateLimited ~= nil then HttpService:JSONEncode(rateLimited) else nil
								v13.responseBody = v14
								return v13
							else
								local formatted = `{v8}:{v9}`

								local reactions2 = cloneReactions(reactions[formatted] or (v7.reactionProjectionsByCommentId or {})[v9] or v12.reactions or {
									counts = {}
								})
								local emoteId = if reactions2.userReaction ~= nil then reactions2.userReaction.emoteId else nil

								if data.method == "PUT" then
									if emoteId == nil or emoteId == v10.emoteId then
										if emoteId == nil then
											local v14 = false

											for k, count in reactions2.counts do
												if count.emoteId ~= v10.emoteId then
													continue
												end

												count.count += 1
												v14 = true
											end

											if not v14 then
												table.insert(reactions2.counts, {
													emoteId = v10.emoteId,
													count = 1
												})
											end

											reactions2.userReaction = {
												emoteId = v10.emoteId
											}
										end
									else
										local v14 = {
											errorCode = "ReactionTypeConflict",
											message = "a different reaction is selected"
										}
										local v16 = if v14 ~= nil then HttpService:JSONEncode(v14) else nil
										return {
											statusCode = 409,
											headers = nil,
											responseBody = v16
										}
									end
								elseif data.method == "DELETE" then
									if emoteId == v10.emoteId then
										for k, count in reactions2.counts do
											if count.emoteId == v10.emoteId then
												count.count = math.max(0, count.count - 1)
											end
										end

										reactions2.userReaction = nil
									end
								else
									local v14 = {
										errorCode = "CommentsUnavailable",
										message = `unsupported reaction method {data.method}`
									}
									local v16 = if v14 ~= nil then HttpService:JSONEncode(v14) else nil
									return {
										statusCode = 405,
										headers = nil,
										responseBody = v16
									}
								end

								reactions[formatted] = reactions2
								return { statusCode = 204, responseBody = nil }
							end
						end
					end
				end
			},
			{
				pattern = "/comments",
				respond = function(data)
					local method = data.method

					if method == "GET" then
						local url = data.url
						local v8 = string.match(url, "/moments/([^/]+)/comments") or "feed-1"

						local url2 = data.url
						local v9 = string.match(url2, "/comments/([^/?]+)$")

						if v9 == nil then
							local v10 = parseQuery(data.url)
							local pageForCursor = MockCommentsPages.pageForCursor(v8, v10.cursor, unixTimestamp)
							local v11 = pageWithMutations(v8, v10.cursor, pageForCursor)
							local v13 = if v11 ~= nil then HttpService:JSONEncode(v11) else nil
							return {
								statusCode = 200,
								headers = nil,
								responseBody = v13
							}
						else
							local comment = findComment(v8, v9)

							if comment == nil then
								local v10 = {
									errorCode = "CommentNotFound",
									message = "comment was not found for the requested moment"
								}
								local v12 = if v10 ~= nil then HttpService:JSONEncode(v10) else nil
								return {
									statusCode = 404,
									headers = nil,
									responseBody = v12
								}
							else
								local commentsByCommentId = v5[comment.feedItemId]

								if commentsByCommentId == nil then
									commentsByCommentId = {}
									v5[comment.feedItemId] = commentsByCommentId
								end

								commentsByCommentId[comment.commentId] = comment

								local v10 = toApiComment(comment)
								local v11 = reactions[`{v8}:{v9}`]
									or (v7.reactionProjectionsByCommentId or {})[v9]

								if v11 ~= nil then
									v10.reactions = cloneReactions(v11)
								end

								local v13 = if v10 ~= nil then HttpService:JSONEncode(v10) else nil
								return {
									statusCode = 200,
									headers = nil,
									responseBody = v13
								}
							end
						end
					elseif method == "POST" then
						local v8 = decodeBody(data.body)
						local clientRequestId = v8.clientRequestId
						local url = data.url
						local v9 = string.match(url, "/moments/([^/]+)/comments") or "feed-1"

						local v10 = if type(clientRequestId) == "string" then `{v9}:{clientRequestId}` else nil

						local postOutcome = v7.postOutcome or "success"

						if postOutcome == "timeout" then
							error("createCommentsMockNetwork: simulated timeout")
						end

						if postOutcome == "TextFilterRejected" then
							local textFilterRejected = CommentFixtures.ERRORS.TextFilterRejected
							local v12 = if textFilterRejected ~= nil then HttpService:JSONEncode(textFilterRejected) else nil
							return {
								statusCode = 422,
								headers = nil,
								responseBody = v12
							}
						elseif postOutcome == "RateLimited" then
							local rateLimited = CommentFixtures.ERRORS.RateLimited
							local v12 = if rateLimited ~= nil then HttpService:JSONEncode(rateLimited) else nil
							return {
								statusCode = 429,
								headers = nil,
								responseBody = v12
							}
						elseif v10 == nil or comments[v10] == nil then
							local clone = table.clone(CommentFixtures.AUTHORS.roblox)
							clone.userId = v7.postAuthorUserId or clone.userId
							local comment = CommentFixtures.makeComment({
								commentId = `posted-{v9}-{clientRequestId or HttpService:GenerateGUID(false)}`,
								feedItemId = v9,
								text = type(v8.text) ~= "string" and "" or v8.text,
								createdAt = DateTime.now():ToIsoDate(),
								isAuthoredByViewer = true,
								author = clone
							})

							if v10 ~= nil then
								comments[v10] = comment
							end

							local v11 = v6[v9] or {}
							table.insert(v11, 1, comment)
							v6[v9] = v11
							local commentsByCommentId = v5[comment.feedItemId]

							if commentsByCommentId == nil then
								commentsByCommentId = {}
								v5[comment.feedItemId] = commentsByCommentId
							end

							commentsByCommentId[comment.commentId] = comment

							if postOutcome == "replay" then
								local v12 = toApiComment(comment)
								local v14 = if v12 ~= nil then HttpService:JSONEncode(v12) else nil
								return {
									statusCode = 200,
									headers = nil,
									responseBody = v14
								}
							else
								local v12 = toApiComment(comment)
								local v14 = if v12 ~= nil then HttpService:JSONEncode(v12) else nil
								return {
									statusCode = 201,
									headers = nil,
									responseBody = v14
								}
							end
						else
							local v11 = toApiComment(comments[v10])
							local v13 = if v11 ~= nil then HttpService:JSONEncode(v11) else nil
							return {
								statusCode = 200,
								headers = nil,
								responseBody = v13
							}
						end
					elseif method == "DELETE" then
						local url = data.url
						local v8 = string.match(url, "/moments/([^/]+)/comments") or "feed-1"

						local url2 = data.url
						local v9 = string.match(url2, "/comments/([^/?]+)$")

						if v9 == nil then
							local v10 = {
								errorCode = "CommentsUnavailable",
								message = "invalid author-comment DELETE path"
							}
							local v12 = if v10 ~= nil then HttpService:JSONEncode(v10) else nil
							return {
								statusCode = 405,
								headers = nil,
								responseBody = v12
							}
						else
							local formatted = `{v8}:{v9}`

							set[formatted] = true
							local v10 = v5[v8]

							if v10 ~= nil then
								v10[v9] = nil
							end

							return { statusCode = 204, responseBody = nil }
						end
					else
						local v8 = {
							errorCode = "CommentsUnavailable",
							message = `unsupported method {method}`
						}
						local v10 = if v8 ~= nil then HttpService:JSONEncode(v8) else nil
						return { statusCode = 405, headers = nil, responseBody = v10 }
					end
				end
			}
		}
	})

	local function latencyForRequest(p2)
		if string.find(p2.url, "/reactions", 1, true) then
			return v7.reactionLatencySeconds or v7.latencySeconds
		end

		local method = p2.method

		if method == "GET" then
			return v7.fetchLatencySeconds or v7.latencySeconds
		elseif method == "POST" then
			return v7.postLatencySeconds or v7.latencySeconds
		end

		return v7.latencySeconds
	end

	return {
		request = function(p2, p3)
			local v8

			if string.find(p2.url, "/reactions", 1, true) then
				v8 = v7.reactionLatencySeconds or v7.latencySeconds
			else
				local method = p2.method

				if method == "GET" then
					v8 = v7.fetchLatencySeconds or v7.latencySeconds
				else
					v8 = if method == "POST" then v7.postLatencySeconds or v7.latencySeconds else v7.latencySeconds
				end
			end

			if type(v8) ~= "number" or v8 <= 0 then
				return mockNetwork.request(p2, p3)
			end

			local flag = false
			local v9 = nil
			local v10 = (v7.schedule or scheduleDelay)(v8, function()
				if not flag then
					v9 = mockNetwork.request(p2, p3)
				end
			end)

			return function()
				if flag then
					return
				end

				flag = true
				v10()

				if v9 ~= nil then
					v9()
				end
			end
		end
	}
end

return createCommentsMockNetwork
