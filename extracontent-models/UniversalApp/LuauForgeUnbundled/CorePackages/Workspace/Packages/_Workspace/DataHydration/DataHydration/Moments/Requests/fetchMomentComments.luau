local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")
local convertApiCommentToComment = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/convertApiCommentToComment")
local fFlagEnableMomentsCommentReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagEnableMomentsCommentReporting

local function commentsPath(p2)
	return `moment-comments-api/v1/moments/{p2}/comments`
end

local function decodeCommentsPage(data)
	local v5 = {}

	if type(data) == "table" and type(data.comments) == "table" then
		for k, comment in data.comments do
			local v6 = convertApiCommentToComment(comment)

			if v6 ~= nil then
				table.insert(v5, v6)
			end
		end
	end

	local v7 = if fFlagEnableMomentsCommentReporting and type(data) == "table" and type(data.channelId) == "string" and data.channelId ~= "" then data.channelId else nil

	local v8 = if type(data) == "table" and type(data.nextCursor) == "string" then data.nextCursor else nil
	return {
		comments = v5,
		channelId = v7,
		nextCursor = v8,
		hasMore = type(data) == "table" and data.hasMore == true
	}
end

local function fetchMomentComments(data, p2)
	local v5, v6 = constructApiUrl(`moment-comments-api/v1/moments/{data.feedItemId}/comments`)
	local queryString = Http.Url:makeQueryString({
		cursor = data.cursor,
		limit = data.limit,
		sort = data.sort
	})

	if queryString ~= "" then
		v5 = `{v5}?{queryString}`
	end

	return HttpClient.fetch({
		method = "GET",
		url = v5,
		headers = v6,
		analyticsKey = "moments.get-comments",
		network = p2,
		decode = decodeCommentsPage
	})
end

return fetchMomentComments
