local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

require(script.Parent.ShareLinkMetadataStoreTypes)

local function normalizeId(p) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return nil
	end

	return (tostring(p))
end

local function fetchShareLinkMetadata(linkId: string, linkType: string, options)
	local v = options or {}
	local fetched = HttpClient.fetch({
		network = v.network,
		method = "POST",
		url = (v.baseUrl or UrlBase.APIS) .. "/sharelinks/v1/get-metadata",
		body = { linkId = linkId, linkType = linkType },
		analyticsKey = "share-link-metadata.get",
		decode = function(p)
			if p.data == nil then
				error("Share link metadata response is missing data")
			end

			local jsonDecode = HttpService:JSONDecode(p.data)
			return {
				universeId = normalizeId(jsonDecode.universeId), -- inferred equivalent call
				placeId = normalizeId(jsonDecode.placeId) -- inferred equivalent call
			}
		end
	})

	return HttpClient.asPromise(fetched)
end

return fetchShareLinkMetadata
