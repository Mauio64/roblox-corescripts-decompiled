local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/Signals")
local fFlagHideOfferNotificationsWhenShopEmpty = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/SharedFlags").FFlagHideOfferNotificationsWhenShopEmpty

local GetOffersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Stores/GetOffersStore")
local getOfferBadgeText = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getOfferBadgeText")

local function createOfferBadgeTextSignal(p2)
	return Signals.createComputed(function(p3)
		if fFlagHideOfferNotificationsWhenShopEmpty and not GetOffersStore(false).getShopHasItems(p3) then
			return nil
		end

		return getOfferBadgeText(GetOffersStore(false).getOffers(p3), p2)
	end)
end

return createOfferBadgeTextSignal
