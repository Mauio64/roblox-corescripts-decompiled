local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpService = game:GetService("HttpService")

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)
local MomentsTypes = require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)

local url = Http.Url.APIS_URL .. "deeplinks/v2/get-or-create-static"

local ShareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function decodeShareLink(p)
	return if p.link and type(p.link) == "string" then p.link else nil
end

local function fetchShareLink(data, network)
	local v = { momentId = data.momentId }
	local feedItemId = data.feedItemId
	local v2 = feedItemId ~= nil and feedItemId ~= ""
	assert(v2, "feedItemId is required to create a Moments share link")

	v.targetIdType = ShareLinkTargetIdType.FeedItemId
	return HttpClient.fetch({
		method = "POST",
		url = url,
		body = {
			linkType = 6,
			targetId = feedItemId,
			linkPreviewTitle = data.title,
			linkPreviewDescription = data.description or "",
			linkPreviewAssetId = 0,
			customData = HttpService:JSONEncode(v)
		},
		analyticsKey = "moments.get-or-create-static-share-link",
		network = network,
		decode = decodeShareLink
	})
end

return fetchShareLink
