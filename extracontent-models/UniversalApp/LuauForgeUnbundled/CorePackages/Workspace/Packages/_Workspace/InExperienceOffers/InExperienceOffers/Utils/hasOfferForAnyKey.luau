local getOffersForKey = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getOffersForKey")

require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local function hasOfferForAnyKey(p2, items): boolean
	for k, item in items do
		if getOffersForKey(p2, item) ~= nil then
			return true
		end
	end

	return false
end

return hasOfferForAnyKey
