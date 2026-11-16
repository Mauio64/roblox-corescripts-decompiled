local FFlagOffersRespectExpiration = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FFlagOffersRespectExpiration")
local isOfferExpired = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/isOfferExpired")

require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local function selectActiveOffer(items, p2)
	if items == nil then
		return nil
	end

	for k, item in items do
		local presentationData = item.presentationData

		if
			item.offerStatus == "AVAILABLE"
			and presentationData ~= nil
			and presentationData[p2] ~= nil
			and not (FFlagOffersRespectExpiration and isOfferExpired(item))
		then
			return {
				offerId = item.offerId,
				offerStatus = item.offerStatus,
				featureKeys = item.featureKeys,
				expirationTimeInUTC = item.expirationTimeInUTC,
				presentationData = presentationData
			}
		end
	end

	return nil
end

return selectActiveOffer
