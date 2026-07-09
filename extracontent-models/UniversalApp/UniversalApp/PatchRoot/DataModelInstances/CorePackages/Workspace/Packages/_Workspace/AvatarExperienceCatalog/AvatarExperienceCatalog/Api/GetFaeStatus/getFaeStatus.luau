local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Url = require(AvatarExperienceCatalogParent.Http).Url

require(AvatarExperienceCatalogParent.LuauPolyfill)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeFaeStatus = require(script.Parent.normalizeFaeStatus)
local constants = require(script.Parent.constants)

return {
	getFaeStatus = function(p1: ((...any) -> ...any)) -- line: 14
		-- upvalues: Url (copy), makeAXResponseHandler (copy), normalizeFaeStatus (copy), constants (copy)
		local v8 = Url:makeQueryString({
			featureNames = "ShowFaeUpsellInMarketplace,AllowFaeItemToBeClaimed",
			nameSpace = "avatar_marketplace_user_journey/MarketplaceUserJourney"
		})
		local v9, v10 = p1(`{ Url.APIS_URL }access-management/v1/feature-access?{ v8 }`, "GET")

		return makeAXResponseHandler(v9, normalizeFaeStatus, {
			modelMismatchCounter = constants.FETCH_FAE_STATUS_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_FAE_STATUS_LATENCY_COUNTER_NAME
		}), v10
	end
}
