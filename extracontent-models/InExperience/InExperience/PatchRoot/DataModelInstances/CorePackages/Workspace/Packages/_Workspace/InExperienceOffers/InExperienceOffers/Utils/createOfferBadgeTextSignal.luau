local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")
local parent = InExperienceOffers.Parent

local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local FFlagHideOfferNotificationsWhenShopEmpty = SharedFlags.FFlagHideOfferNotificationsWhenShopEmpty

local GetOffersStore = require(InExperienceOffers.Stores.GetOffersStore)
local getOfferBadgeText = require(InExperienceOffers.Utils.getOfferBadgeText)

local function createOfferBadgeTextSignal(p: string)
	return Signals.createComputed(function(p2)
		if FFlagHideOfferNotificationsWhenShopEmpty and not GetOffersStore(false).getShopHasItems(p2) then
			return nil
		end

		return getOfferBadgeText(GetOffersStore(false).getOffers(p2), p)
	end)
end

return createOfferBadgeTextSignal
