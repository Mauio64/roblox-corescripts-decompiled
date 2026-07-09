local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpService = game:GetService("HttpService")
local Http = require(DataHydrationParent.Http)
local HttpClient = require(DataHydrationParent.HttpClient)

require(DataHydration.Moments.MomentsStoreTypes)

local v6 = Http.Url.APIS_URL .. "deeplinks/v2/get-or-create-static"

local function decodeShareLink(t1: {[any]: any}) -- line: 26
	if t1.link and type(t1.link) == "string" then
		return t1.link
	end

	return nil
end
local function fetchShareLink(t2: {[any]: any}, p1) -- line: 34
	-- upvalues: HttpClient (copy), v6 (copy), HttpService (copy), decodeShareLink (copy)
	return HttpClient.fetch({
		method = "POST",
		analyticsKey = "moments.get-or-create-static-share-link",
		url = v6,
		body = {
			linkType = 6,
			linkPreviewAssetId = 0,
			targetId = t2.momentId,
			linkPreviewTitle = t2.title,
			linkPreviewDescription = t2.description or "",
			customData = HttpService:JSONEncode({
				momentId = t2.momentId
			})
		},
		network = p1,
		decode = decodeShareLink
	})
end

return fetchShareLink
