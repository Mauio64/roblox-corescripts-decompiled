local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")

local FFlagOffersRespectExpiration = require(InExperienceOffers.Flags.FFlagOffersRespectExpiration)
local isOfferExpired = require(InExperienceOffers.Utils.isOfferExpired)

require(InExperienceOffers.Types)

local function selectActiveOffer(items, p: string)
	if items == nil then
		return nil
	end

	for _, item in items do
		local presentationData = item.presentationData

		if
			item.offerStatus == "AVAILABLE"
			and presentationData ~= nil
			and presentationData[p] ~= nil
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
