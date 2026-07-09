local HttpService = game:GetService("HttpService")
local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Url = require(AvatarExperienceCatalogParent.Http).Url

require(AvatarExperienceCatalogParent.LuauPolyfill)
require(AvatarExperienceCatalog.Models.CatalogV2SearchItemDetails)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeCatalogV2SearchItemDetails = require(script.Parent.normalizeCatalogV2SearchItemDetails)
local constants = require(script.Parent.constants)
local t1 = {
	assetTypeIds = true,
	bundleTypeIds = true
}

local function buildQueryStringWithArrayParams(p1) -- line: 20
	-- upvalues: t1 (copy), HttpService (copy)
	local t2 = {}

	for v12, v13 in p1 do
		if t1[v12] and type(v13) == "table" then
			for _, v15 in v13 do
				table.insert(t2, `{ v12 }={ HttpService:UrlEncode((tostring(v15))) }`)
			end
		elseif not t1[v12] then
			table.insert(t2, `{ v12 }={ HttpService:UrlEncode((tostring(v13))) }`)
		end
	end

	return table.concat(t2, "&")
end

return {
	getCatalogV2SearchItemDetails = function(p2: ((...any) -> ...any), p3) -- line: 38
		-- upvalues: buildQueryStringWithArrayParams (copy), Url (copy), makeAXResponseHandler (copy), normalizeCatalogV2SearchItemDetails (copy), constants (copy)
		local v18 = buildQueryStringWithArrayParams(p3)
		local v19, v20 = p2(`{ Url.CATALOG_URL }v2/search/items/details?{ v18 }`, "GET")

		return makeAXResponseHandler(v19, normalizeCatalogV2SearchItemDetails, {
			modelMismatchCounter = constants.FETCH_CATALOG_V2_SEARCH_ITEM_DETAILS_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_CATALOG_V2_SEARCH_ITEM_DETAILS_LATENCY_COUNTER_NAME
		}), v20
	end,
	buildQueryStringWithArrayParams = buildQueryStringWithArrayParams
}
