local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpService = game:GetService("HttpService")
local Http = require(DataHydrationParent.Http)
local HttpClient = require(DataHydrationParent.HttpClient)
local MomentsTypes = require(DataHydrationParent.MomentsTypes)
local SharedFlags = require(DataHydrationParent.SharedFlags)

require(DataHydration.Moments.MomentsStoreTypes)

local v8 = Http.Url.APIS_URL .. "deeplinks/v2/get-or-create-static"
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis
local ShareLinkTargetIdType = MomentsTypes.Enums.ShareLinkTargetIdType

local function decodeShareLink(t1: {[any]: any}) -- line: 33
	if t1.link and type(t1.link) == "string" then
		return t1.link
	end

	return nil
end
local function fetchShareLink(t2: {[any]: any}, p1) -- line: 41
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), ShareLinkTargetIdType (copy), HttpClient (copy), v8 (copy), HttpService (copy), decodeShareLink (copy)
	local momentId = t2.momentId
	local t3 = {
		momentId = t2.momentId
	}

	if FFlagMomentsPassFeedItemIdToBackendApis then
		momentId = t2.feedItemId
		assert(momentId ~= nil and momentId ~= "", "feedItemId is required to create a Moments share link")
		t3.targetIdType = ShareLinkTargetIdType.FeedItemId
	end

	return HttpClient.fetch({
		method = "POST",
		analyticsKey = "moments.get-or-create-static-share-link",
		url = v8,
		body = {
			linkType = 6,
			linkPreviewAssetId = 0,
			targetId = momentId,
			linkPreviewTitle = t2.title,
			linkPreviewDescription = t2.description or "",
			customData = HttpService:JSONEncode(t3)
		},
		network = p1,
		decode = decodeShareLink
	})
end

return fetchShareLink
