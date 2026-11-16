local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/SignalsReact")

local GetOffersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Stores/GetOffersStore")

local function useShopHasItems()
	return SignalsReact.useSignalState(GetOffersStore(false).getShopHasItems)
end

return useShopHasItems
