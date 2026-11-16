local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")

local getOffersForKey = require(InExperienceOffers.Utils.getOffersForKey)

require(InExperienceOffers.Types)

local function hasOfferForAnyKey(p, items): boolean
	for _, item in items do
		if getOffersForKey(p, item) ~= nil then
			return true
		end
	end

	return false
end

return hasOfferForAnyKey
