local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/CatalogV2SearchItemDetails")
local makeAXResponseHandler = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/makeAXResponseHandler")
local normalizeCatalogV2SearchItemDetails = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/normalizeCatalogV2SearchItemDetails")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/constants")

local v5 = { assetTypeIds = true, bundleTypeIds = true }

if require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter then
	v5.requiredPropertyFilters = true
end

local function buildQueryStringWithArrayParams(items)
	local v6 = {}

	for k, item in items do
		if v5[k] and type(item) == "table" then
			for k2, v7 in item do
				table.insert(v6, `{k}={HttpService:UrlEncode((tostring(v7)))}`)
			end
		elseif not v5[k] then
			table.insert(v6, `{k}={HttpService:UrlEncode((tostring(item)))}`)
		end
	end

	return table.concat(v6, "&")
end

return {
	getCatalogV2SearchItemDetails = function(callback, p2)
		local queryStringWithArrayParams = buildQueryStringWithArrayParams(p2)
		local v6, v7 = callback(
			`{url.CATALOG_URL}v2/search/items/details?{queryStringWithArrayParams}`,
			"GET"
		)

		return
			makeAXResponseHandler(v6, normalizeCatalogV2SearchItemDetails, {
				modelMismatchCounter = constants.FETCH_CATALOG_V2_SEARCH_ITEM_DETAILS_MODEL_MISMATCH_COUNTER_NAME,
				latencyCounter = constants.FETCH_CATALOG_V2_SEARCH_ITEM_DETAILS_LATENCY_COUNTER_NAME
			}),
			v7
	end,
	buildQueryStringWithArrayParams = buildQueryStringWithArrayParams
}
