local HttpService = game:GetService("HttpService")

local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)
local isCanonicalNonzeroUuid = require(DataHydration.Moments.Util.isCanonicalNonzeroUuid)
local CommentFixtures = require(script.Parent.CommentFixtures)
local MockCommentsPages = require(script.Parent.MockCommentsPages)

local function parseQuery(url: string)
	local query = {}
	local v = string.find(url, "?", 1, true)

	if v == nil then
		return query
	end

	for k in string.gmatch(string.sub(url, v + 1), "[^&]+") do
		local v2, v3 = string.match(k, "([^=]+)=?(.*)")

		if v2 ~= nil then
			query[v2] = v3 or ""
		end
	end

	return query
end

local function feedItemIdFromCommentsUrl(url: string) -- 3 equivalent calls inferred from this helper
	return string.match(url, "/moments/([^/]+)/comments") or "feed-1"
end

local function commentIdFromDeleteUrl(url: string) -- 2 equivalent calls inferred from this helper
	return string.match(url, "/comments/([^/?]+)$")
end

local function reactionIdsFromUrl(url: string) -- 1 equivalent call inferred from this helper
	return string.match(url, "/moments/([^/]+)/comments/([^/]+)/reactions$")
end

local function commentKey(p: string, p2: string) -- 8 equivalent calls inferred from this helper
	return `{p}:{p2}`
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

local function json(statusCode: number, p, headers) -- 16 equivalent calls inferred from this helper
	local responseBody

	if p ~= nil then
		responseBody = HttpService:JSONEncode(p)
	end

	return { statusCode = statusCode, headers = headers, responseBody = responseBody }
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
	local authorUserId

	if data.author ~= nil then
		authorUserId = data.author.userId
	end

	apiComment.authorUserId = authorUserId
	apiComment.text = data.text
	apiComment.translatedText = data.translatedText
	apiComment.createdAt = data.createdAt
	apiComment.isAuthoredByViewer = data.isAuthoredByViewer
	apiComment.reactions = data.reactions
	return apiComment
end

local function cloneReactions(p)
	local clones = table.create(#p.counts)

	for _, count in p.counts do
		table.insert(clones, table.clone(count))
	end

	local userReaction

	if p.userReaction ~= nil then
		userReaction = table.clone(p.userReaction)
	end

	return { counts = clones, userReaction = userReaction }
end

local function scheduleDelay(duration: number, callback)
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
	local v = {}

	local function indexVisibleComment(p) -- 4 equivalent calls inferred from this helper
		local v2 = v[p.feedItemId]

		if v2 == nil then
			v2 = {}
			v[p.feedItemId] = v2
		end

		v2[p.commentId] = p
	end

	local function visibleComment(p: string, p2: string) -- 2 equivalent calls inferred from this helper
		local v2 = v[p]

		if v2 == nil or set[commentKey(p, p2)] then -- inferred equivalent call
			return nil
		end

		return v2[p2]
	end

	local v2 = {}

	local reactions = {}
	local v3 = options or {}

	local comments = {}

	for _, v4 in { CommentFixtures.REACTION_IDS.feedItemId, CommentFixtures.REACTION_IDS.otherFeedItemId } do
		for _, comment in MockCommentsPages.reactionPage(v4, unixTimestamp).comments do
			indexVisibleComment(comment) -- inferred equivalent call
		end
	end

	local function findComment(p: string, p2: string)
		if set[commentKey(p, p2)] then -- inferred equivalent call
			return nil
		end

		local v4 = visibleComment(p, p2) -- inferred equivalent call

		if v4 ~= nil then
			return v4
		end

		for _, v5 in { "", MockCommentsPages.EMPTY_HAS_MORE_CURSOR, MockCommentsPages.PAGE_3_CURSOR } do
			for _, comment in MockCommentsPages.pageForCursor(p, v5, unixTimestamp).comments do
				if comment.commentId == p2 then
					return comment
				end
			end
		end

		return nil
	end

	local function pageWithMutations(p: string, cursor: string?, data)
		local v4 = {}

		if cursor == nil or cursor == "" then
			local v5 = v2[p]

			if v5 ~= nil then
				for _, v6 in v5 do
					if not set[commentKey(v6.feedItemId, v6.commentId)] then -- inferred equivalent call
						table.insert(v4, v6)
					end
				end
			end
		end

		for _, comment in data.comments do
			if not set[commentKey(comment.feedItemId, comment.commentId)] then -- inferred equivalent call
				table.insert(v4, comment)
			end
		end

		local comments2 = {}

		for _, v5 in v4 do
			indexVisibleComment(v5) -- inferred equivalent call
			local v6 = toApiComment(v5)
			local v7 = reactions[commentKey(v5.feedItemId, v5.commentId)] -- inferred equivalent call
				or (v3.reactionProjectionsByCommentId or {})[v5.commentId]

			if v7 ~= nil then
				v6.reactions = cloneReactions(v7)
			end

			table.insert(comments2, v6)
		end

		return { comments = comments2, nextCursor = data.nextCursor, hasMore = data.hasMore }
	end

	local mockNetwork = HttpClient.createMockNetwork({
		routes = {
			{
				pattern = "/reactions",
				respond = function(data)
					local v4, v5 = reactionIdsFromUrl(data.url) -- inferred equivalent call
					local v6 = decodeBody(data.body)

					if
						v4 == nil
						or v5 == nil
						or not isCanonicalNonzeroUuid(v4)
						or not isCanonicalNonzeroUuid(v5)
						or v6.reactionType ~= "thumbsup"
						or not isCanonicalNonzeroUuid(v6.emoteId)
					then
						return json(400, { -- inferred equivalent call
							errorCode = "InvalidRequest",
							message = "invalid reaction request"
						})
					else
						local v7 = visibleComment(v4, v5) -- inferred equivalent call

						if v7 == nil then
							return json(404, { -- inferred equivalent call
								errorCode = "CommentNotFound",
								message = "comment was not found for the requested moment"
							})
						else
							local reactionOutcome = v3.reactionOutcome or "success"

							if reactionOutcome == "timeout" then
								error("createCommentsMockNetwork: simulated reaction timeout")
							end

							if reactionOutcome == "ViewerNotEligibleToReact" then
								return json(403, CommentFixtures.ERRORS.ViewerNotEligibleToReact) -- inferred equivalent call
							elseif reactionOutcome == "RateLimited" then
								return json(429, CommentFixtures.ERRORS.RateLimited, { -- inferred equivalent call
									["retry-after"] = v3.reactionRetryAfter or "10"
								})
							else
								local v8 = commentKey(v4, v5) -- inferred equivalent call
								local reactions2 = cloneReactions(reactions[v8] or (v3.reactionProjectionsByCommentId or {})[v5] or v7.reactions or {
									counts = {}
								})
								local emoteId

								if reactions2.userReaction ~= nil then
									emoteId = reactions2.userReaction.emoteId
								end

								if data.method == "PUT" then
									if emoteId == nil or emoteId == v6.emoteId then
										if emoteId == nil then
											local v9 = false

											for _, count in reactions2.counts do
												if count.emoteId ~= v6.emoteId then
													continue
												end

												count.count += 1
												v9 = true
											end

											if not v9 then
												table.insert(reactions2.counts, {
													emoteId = v6.emoteId,
													count = 1
												})
											end

											reactions2.userReaction = { emoteId = v6.emoteId }
										end
									else
										return json(409, { -- inferred equivalent call
											errorCode = "ReactionTypeConflict",
											message = "a different reaction is selected"
										})
									end
								elseif data.method == "DELETE" then
									if emoteId == v6.emoteId then
										for _, count in reactions2.counts do
											if count.emoteId == v6.emoteId then
												count.count = math.max(0, count.count - 1)
											end
										end

										reactions2.userReaction = nil
									end
								else
									return json(405, { -- inferred equivalent call
										errorCode = "CommentsUnavailable",
										message = `unsupported reaction method {data.method}`
									})
								end

								reactions[v8] = reactions2
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
						local v4 = feedItemIdFromCommentsUrl(data.url) -- inferred equivalent call
						local v5 = commentIdFromDeleteUrl(data.url) -- inferred equivalent call

						if v5 == nil then
							local v6 = parseQuery(data.url)
							local pageForCursor = MockCommentsPages.pageForCursor(v4, v6.cursor, unixTimestamp)
							return json(200, pageWithMutations(v4, v6.cursor, pageForCursor), nil) -- inferred equivalent call
						else
							local comment = findComment(v4, v5)

							if comment == nil then
								return json(404, { -- inferred equivalent call
									errorCode = "CommentNotFound",
									message = "comment was not found for the requested moment"
								})
							else
								indexVisibleComment(comment) -- inferred equivalent call
								local v6 = toApiComment(comment)
								local v7 = reactions[commentKey(v4, v5)] -- inferred equivalent call
									or (v3.reactionProjectionsByCommentId or {})[v5]

								if v7 ~= nil then
									v6.reactions = cloneReactions(v7)
								end

								return json(200, v6) -- inferred equivalent call
							end
						end
					elseif method == "POST" then
						local v4 = decodeBody(data.body)
						local clientRequestId = v4.clientRequestId
						local feedItemId = feedItemIdFromCommentsUrl(data.url) -- inferred equivalent call
						local v5

						if type(clientRequestId) == "string" then
							v5 = `{feedItemId}:{clientRequestId}`
						end

						local postOutcome = v3.postOutcome or "success"

						if postOutcome == "timeout" then
							error("createCommentsMockNetwork: simulated timeout")
						end

						if postOutcome == "TextFilterRejected" then
							return json(422, CommentFixtures.ERRORS.TextFilterRejected) -- inferred equivalent call
						elseif postOutcome == "RateLimited" then
							return json(429, CommentFixtures.ERRORS.RateLimited) -- inferred equivalent call
						elseif v5 == nil or comments[v5] == nil then
							local clone = table.clone(CommentFixtures.AUTHORS.roblox)
							clone.userId = v3.postAuthorUserId or clone.userId
							local comment = CommentFixtures.makeComment({
								commentId = `posted-{feedItemId}-{clientRequestId or HttpService:GenerateGUID(false)}`,
								feedItemId = feedItemId,
								text = type(v4.text) ~= "string" and "" or v4.text,
								createdAt = DateTime.now():ToIsoDate(),
								isAuthoredByViewer = true,
								author = clone
							})

							if v5 ~= nil then
								comments[v5] = comment
							end

							local v6 = v2[feedItemId] or {}
							table.insert(v6, 1, comment)
							v2[feedItemId] = v6
							indexVisibleComment(comment) -- inferred equivalent call

							if postOutcome == "replay" then
								return json(200, toApiComment(comment), nil) -- inferred equivalent call
							end

							return json(201, toApiComment(comment), nil) -- inferred equivalent call
						else
							return json(200, toApiComment(comments[v5]), nil) -- inferred equivalent call
						end
					elseif method == "DELETE" then
						local v4 = feedItemIdFromCommentsUrl(data.url) -- inferred equivalent call
						local v5 = commentIdFromDeleteUrl(data.url) -- inferred equivalent call

						if v5 == nil then
							return json(405, { -- inferred equivalent call
								errorCode = "CommentsUnavailable",
								message = "invalid author-comment DELETE path"
							})
						else
							local v6 = commentKey(v4, v5) -- inferred equivalent call
							set[v6] = true
							local v7 = v[v4]

							if v7 ~= nil then
								v7[v5] = nil
							end

							return { statusCode = 204, responseBody = nil }
						end
					else
						return json(405, { -- inferred equivalent call
							errorCode = "CommentsUnavailable",
							message = `unsupported method {method}`
						})
					end
				end
			}
		}
	})

	local function latencyForRequest(p) -- 1 equivalent call inferred from this helper
		if string.find(p.url, "/reactions", 1, true) then
			return v3.reactionLatencySeconds or v3.latencySeconds
		end

		local method = p.method

		if method == "GET" then
			return v3.fetchLatencySeconds or v3.latencySeconds
		elseif method == "POST" then
			return v3.postLatencySeconds or v3.latencySeconds
		end

		return v3.latencySeconds
	end

	return {
		request = function(p, callback)
			local v4 = latencyForRequest(p) -- inferred equivalent call

			if type(v4) ~= "number" or v4 <= 0 then
				return mockNetwork.request(p, callback)
			end

			local flag = false
			local v5 = nil
			local v6 = (v3.schedule or scheduleDelay)(v4, function()
				if not flag then
					v5 = mockNetwork.request(p, callback)
				end
			end)

			return function()
				if flag then
					return
				end

				flag = true
				v6()

				if v5 ~= nil then
					v5()
				end
			end
		end
	}
end

return createCommentsMockNetwork
