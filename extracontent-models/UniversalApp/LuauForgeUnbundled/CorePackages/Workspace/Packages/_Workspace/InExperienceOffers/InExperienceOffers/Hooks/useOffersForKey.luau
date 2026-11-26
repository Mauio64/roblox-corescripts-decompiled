local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/SignalsReact")

local GetOffersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Stores/GetOffersStore")
local getOffersForKey = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getOffersForKey")

require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local function useOffersForKey(p2)
	local v5 = GetOffersStore(false)
	return getOffersForKey(SignalsReact.useSignalState(v5.getOffers), p2)
end

return useOffersForKey
