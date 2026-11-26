local getOffersForKey = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getOffersForKey")
local selectActiveOffer = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/selectActiveOffer")

require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local function getOfferBadgeText(p2, p3)
	if p3 == nil then
		return nil
	end

	local v6 = selectActiveOffer(getOffersForKey(p2, p3), "menuBadge")

	if v6 == nil then
		return nil
	end

	local menuBadge = v6.presentationData.menuBadge

	if menuBadge == nil then
		return nil
	end

	return menuBadge.title
end

return getOfferBadgeText
