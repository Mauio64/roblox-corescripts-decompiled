local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local Http = require(parent.Http)
local Url = Http.Url
require(parent.LuauPolyfill)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeFaeStatus = require(script.Parent.normalizeFaeStatus)
local constants = require(script.Parent.constants)

return {
	getFaeStatus = function(callback)
		local queryString = Url:makeQueryString({
			featureNames = "ShowFaeUpsellInMarketplace,AllowFaeItemToBeClaimed",
			nameSpace = "avatar_marketplace_user_journey/MarketplaceUserJourney"
		})

		local v, v2 = callback(`{Url.APIS_URL}access-management/v1/feature-access?{queryString}`, "GET")

		return
			makeAXResponseHandler(v, normalizeFaeStatus, {
				modelMismatchCounter = constants.FETCH_FAE_STATUS_MODEL_MISMATCH_COUNTER_NAME,
				latencyCounter = constants.FETCH_FAE_STATUS_LATENCY_COUNTER_NAME
			}),
			v2
	end
}
