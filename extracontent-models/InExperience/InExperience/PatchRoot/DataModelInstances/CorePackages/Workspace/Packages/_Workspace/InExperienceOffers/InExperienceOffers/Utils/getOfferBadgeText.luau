local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")

local getOffersForKey = require(InExperienceOffers.Utils.getOffersForKey)
local selectActiveOffer = require(InExperienceOffers.Utils.selectActiveOffer)

require(InExperienceOffers.Types)

local function getOfferBadgeText(p, p2: string?)
	if p2 == nil then
		return nil
	end

	local v = selectActiveOffer(getOffersForKey(p, p2), "menuBadge")

	if v == nil then
		return nil
	end

	local menuBadge = v.presentationData.menuBadge
	return if menuBadge ~= nil then menuBadge.title else nil
end

return getOfferBadgeText
