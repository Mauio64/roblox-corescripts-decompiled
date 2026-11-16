local HttpService = game:GetService("HttpService")

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")

local v5 = Http.Url.APIS_URL .. "deeplinks/v2/get-or-create-static"

local shareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function decodeShareLink(p2)
	if p2.link and type(p2.link) == "string" then
		return p2.link
	end

	return nil
end

local function fetchShareLink(data, p2)
	local v6 = { momentId = data.momentId }
	local feedItemId = data.feedItemId
	local v7 = feedItemId ~= nil and feedItemId ~= ""
	assert(v7, "feedItemId is required to create a Moments share link")

	v6.targetIdType = shareLinkTargetIdType.FeedItemId
	return HttpClient.fetch({
		method = "POST",
		url = v5,
		body = {
			linkType = 6,
			targetId = feedItemId,
			linkPreviewTitle = data.title,
			linkPreviewDescription = data.description or "",
			linkPreviewAssetId = 0,
			customData = HttpService:JSONEncode(v6)
		},
		analyticsKey = "moments.get-or-create-static-share-link",
		network = p2,
		decode = decodeShareLink
	})
end

return fetchShareLink
