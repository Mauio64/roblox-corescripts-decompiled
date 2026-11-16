local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)
require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local convertApiCommentToComment = require(DataHydration.Moments.Util.convertApiCommentToComment)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting

local function commentsPath(feedItemId: string) -- 1 equivalent call inferred from this helper
	return `moment-comments-api/v1/moments/{feedItemId}/comments`
end

local function decodeCommentsPage(data)
	local comments = {}

	if type(data) == "table" and type(data.comments) == "table" then
		for _, comment in data.comments do
			local v = convertApiCommentToComment(comment)

			if v ~= nil then
				table.insert(comments, v)
			end
		end
	end

	local channelId

	if
		FFlagEnableMomentsCommentReporting
		and type(data) == "table"
		and type(data.channelId) == "string"
		and data.channelId ~= ""
	then
		channelId = data.channelId
	end

	local nextCursor

	if type(data) == "table" and type(data.nextCursor) == "string" then
		nextCursor = data.nextCursor
	end

	return {
		comments = comments,
		channelId = channelId,
		nextCursor = nextCursor,
		hasMore = type(data) == "table" and data.hasMore == true
	}
end

local function fetchMomentComments(data, network)
	local url, headers = constructApiUrl(commentsPath(data.feedItemId)) -- inferred equivalent call
	local queryString = Http.Url:makeQueryString({
		cursor = data.cursor,
		limit = data.limit,
		sort = data.sort
	})

	if queryString ~= "" then
		url = `{url}?{queryString}`
	end

	return HttpClient.fetch({
		method = "GET",
		url = url,
		headers = headers,
		analyticsKey = "moments.get-comments",
		network = network,
		decode = decodeCommentsPage
	})
end

return fetchMomentComments
