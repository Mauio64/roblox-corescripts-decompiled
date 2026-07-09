local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent

require(AvatarExperienceCatalogParent.AvatarExperienceCommon)

local Url = require(AvatarExperienceCatalogParent.Http).Url

require(AvatarExperienceCatalogParent.LuauPolyfill)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeCatalogCategories = require(script.Parent.normalizeCatalogCategories)
local constants = require(script.Parent.constants)

return {
	getCatalogCategories = function(p1: ((...any) -> ...any), n1: number) -- line: 15
		-- upvalues: Url (copy), makeAXResponseHandler (copy), normalizeCatalogCategories (copy), constants (copy)
		local v9 = Url:makeQueryString({
			versionId = n1
		})
		local v10, v11 = p1(`{ Url.APIS_URL }marketplace-widgets/v1/pills?{ v9 }`, "GET")

		return makeAXResponseHandler(v10, normalizeCatalogCategories, {
			modelMismatchCounter = constants.FETCH_CATALOG_CATEGORIES_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_CATALOG_CATEGORIES_LATENCY_COUNTER_NAME
		}), v11
	end
}
