local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")
local parent = InExperienceOffers.Parent

local SignalsReact = require(parent.SignalsReact)

local GetOffersStore = require(InExperienceOffers.Stores.GetOffersStore)
local getOffersForKey = require(InExperienceOffers.Utils.getOffersForKey)

require(InExperienceOffers.Types)

local function useOffersForKey(p: string)
	local offersStore = GetOffersStore(false)
	return getOffersForKey(SignalsReact.useSignalState(offersStore.getOffers), p)
end

return useOffersForKey
