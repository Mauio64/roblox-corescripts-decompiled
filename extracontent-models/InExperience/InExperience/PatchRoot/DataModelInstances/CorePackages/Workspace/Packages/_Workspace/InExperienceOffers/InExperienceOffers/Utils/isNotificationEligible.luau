local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")

require(InExperienceOffers.Types)

local FFlagOffersRespectExpiration = require(InExperienceOffers.Flags.FFlagOffersRespectExpiration)
local isOfferExpired = require(InExperienceOffers.Utils.isOfferExpired)

local defineFastInt = game:DefineFastInt("InExperienceOffersNotificationMaxExposureCount", 3)

local defineFastInt2 = game:DefineFastInt("InExperienceOffersNotificationCooldownSeconds", 86400)

local function isNotificationEligible(p, p2): boolean
	if p.offerStatus ~= "AVAILABLE" or FFlagOffersRespectExpiration and isOfferExpired(p) then
		return false
	end

	local v = p2[p.offerId]

	if v == nil then
		return true
	end

	if defineFastInt <= v.exposureCount then
		return false
	end

	local dateTime = DateTime.fromIsoDate(v.lastExposureUTCTime)

	return dateTime ~= nil and defineFastInt2 <= DateTime.now().UnixTimestamp - dateTime.UnixTimestamp
end

return isNotificationEligible
