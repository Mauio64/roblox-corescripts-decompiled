local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local makeAXResponseHandler = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/makeAXResponseHandler")
local normalizeFaeStatus = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetFaeStatus/normalizeFaeStatus")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetFaeStatus/constants")

return {
	getFaeStatus = function(callback)
		local queryString = url:makeQueryString({
			featureNames = "ShowFaeUpsellInMarketplace,AllowFaeItemToBeClaimed",
			nameSpace = "avatar_marketplace_user_journey/MarketplaceUserJourney"
		})

		local v5, v6 = callback(`{url.APIS_URL}access-management/v1/feature-access?{queryString}`, "GET")

		return
			makeAXResponseHandler(v5, normalizeFaeStatus, {
				modelMismatchCounter = constants.FETCH_FAE_STATUS_MODEL_MISMATCH_COUNTER_NAME,
				latencyCounter = constants.FETCH_FAE_STATUS_LATENCY_COUNTER_NAME
			}),
			v6
	end
}
