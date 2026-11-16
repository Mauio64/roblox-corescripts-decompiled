local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")
local parent = InExperienceOffers.Parent

local SignalsReact = require(parent.SignalsReact)

local GetOffersStore = require(InExperienceOffers.Stores.GetOffersStore)
local getOfferBadgeText = require(InExperienceOffers.Utils.getOfferBadgeText)

local function useOfferBadgeText(p: string?)
	return getOfferBadgeText(SignalsReact.useSignalState(GetOffersStore(false).getOffers), p)
end

return useOfferBadgeText
