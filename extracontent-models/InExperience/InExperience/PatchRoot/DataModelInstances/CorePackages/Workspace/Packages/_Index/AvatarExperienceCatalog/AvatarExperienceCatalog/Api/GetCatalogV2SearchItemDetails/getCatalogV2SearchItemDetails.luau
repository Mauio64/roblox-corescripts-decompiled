local HttpService = game:GetService("HttpService")

local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local Http = require(parent.Http)
local Url = Http.Url
require(parent.LuauPolyfill)

require(AvatarExperienceCatalog.Models.CatalogV2SearchItemDetails)
local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeCatalogV2SearchItemDetails = require(script.Parent.normalizeCatalogV2SearchItemDetails)
local constants = require(script.Parent.constants)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local v = { assetTypeIds = true, bundleTypeIds = true }

if AvatarExperienceFlags.FFlagAXCatalogSpecialFeaturesFilter then
	v.requiredPropertyFilters = true
end

local function buildQueryStringWithArrayParams(items)
	local v2 = {}

	for k, item in items do
		if v[k] and type(item) == "table" then
			for _, v3 in item do
				table.insert(v2, `{k}={HttpService:UrlEncode((tostring(v3)))}`)
			end
		elseif not v[k] then
			table.insert(v2, `{k}={HttpService:UrlEncode((tostring(item)))}`)
		end
	end

	return table.concat(v2, "&")
end

return {
	getCatalogV2SearchItemDetails = function(callback, p)
		local queryStringWithArrayParams = buildQueryStringWithArrayParams(p)
		local v2, v3 = callback(`{Url.CATALOG_URL}v2/search/items/details?{queryStringWithArrayParams}`, "GET")

		return
			makeAXResponseHandler(v2, normalizeCatalogV2SearchItemDetails, {
				modelMismatchCounter = constants.FETCH_CATALOG_V2_SEARCH_ITEM_DETAILS_MODEL_MISMATCH_COUNTER_NAME,
				latencyCounter = constants.FETCH_CATALOG_V2_SEARCH_ITEM_DETAILS_LATENCY_COUNTER_NAME
			}),
			v3
	end,
	buildQueryStringWithArrayParams = buildQueryStringWithArrayParams
}
