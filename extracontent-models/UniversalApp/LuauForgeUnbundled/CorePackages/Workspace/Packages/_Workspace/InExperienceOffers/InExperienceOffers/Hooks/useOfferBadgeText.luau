local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/SignalsReact")

local GetOffersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Stores/GetOffersStore")
local getOfferBadgeText = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getOfferBadgeText")

local function useOfferBadgeText(p2)
	return getOfferBadgeText(SignalsReact.useSignalState(GetOffersStore(false).getOffers), p2)
end

return useOfferBadgeText
