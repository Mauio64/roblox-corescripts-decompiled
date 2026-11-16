local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
require(parent.AvatarExperienceCommon)
local Http = require(parent.Http)
local Url = Http.Url
require(parent.LuauPolyfill)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeCatalogCategories = require(script.Parent.normalizeCatalogCategories)
local constants = require(script.Parent.constants)

return {
	getCatalogCategories = function(callback, versionId: number)
		local queryString = Url:makeQueryString({ versionId = versionId })

		local v, v2 = callback(`{Url.APIS_URL}marketplace-widgets/v1/pills?{queryString}`, "GET")

		return
			makeAXResponseHandler(v, normalizeCatalogCategories, {
				modelMismatchCounter = constants.FETCH_CATALOG_CATEGORIES_MODEL_MISMATCH_COUNTER_NAME,
				latencyCounter = constants.FETCH_CATALOG_CATEGORIES_LATENCY_COUNTER_NAME
			}),
			v2
	end
}
