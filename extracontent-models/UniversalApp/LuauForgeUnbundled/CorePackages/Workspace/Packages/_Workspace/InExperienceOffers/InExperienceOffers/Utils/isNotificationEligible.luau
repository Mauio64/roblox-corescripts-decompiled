require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local FFlagOffersRespectExpiration = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FFlagOffersRespectExpiration")
local isOfferExpired = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/isOfferExpired")

local defineFastInt = game:DefineFastInt("InExperienceOffersNotificationMaxExposureCount", 3)

local defineFastInt2 = game:DefineFastInt("InExperienceOffersNotificationCooldownSeconds", 86400)

local function isNotificationEligible(p2, p3): boolean
	if p2.offerStatus ~= "AVAILABLE" or FFlagOffersRespectExpiration and isOfferExpired(p2) then
		return false
	end

	local v5 = p3[p2.offerId]

	if v5 == nil then
		return true
	end

	if defineFastInt <= v5.exposureCount then
		return false
	end

	local dateTime = DateTime.fromIsoDate(v5.lastExposureUTCTime)

	if dateTime == nil then
		return false
	end

	return defineFastInt2 <= DateTime.now().UnixTimestamp - dateTime.UnixTimestamp
end

return isNotificationEligible
