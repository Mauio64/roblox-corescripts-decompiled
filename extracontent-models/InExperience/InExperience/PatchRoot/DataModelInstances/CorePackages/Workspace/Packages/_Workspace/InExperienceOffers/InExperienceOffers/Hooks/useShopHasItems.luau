local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")
local parent = InExperienceOffers.Parent

local SignalsReact = require(parent.SignalsReact)

local GetOffersStore = require(InExperienceOffers.Stores.GetOffersStore)

local function useShopHasItems()
	return SignalsReact.useSignalState(GetOffersStore(false).getShopHasItems)
end

return useShopHasItems
