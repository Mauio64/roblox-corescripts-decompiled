require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local makeAXResponseHandler = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/makeAXResponseHandler")
local normalizeCatalogCategories = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogCategories/normalizeCatalogCategories")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogCategories/constants")

return {
	getCatalogCategories = function(callback, p2)
		local queryString = url:makeQueryString({ versionId = p2 })

		local v5, v6 = callback(`{url.APIS_URL}marketplace-widgets/v1/pills?{queryString}`, "GET")

		return
			makeAXResponseHandler(v5, normalizeCatalogCategories, {
				modelMismatchCounter = constants.FETCH_CATALOG_CATEGORIES_MODEL_MISMATCH_COUNTER_NAME,
				latencyCounter = constants.FETCH_CATALOG_CATEGORIES_LATENCY_COUNTER_NAME
			}),
			v6
	end
}
