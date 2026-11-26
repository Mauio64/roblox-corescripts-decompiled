local OffersDebugLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Internal/OffersDebugLogger")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local function isOfferExpired(p2)
	local expirationTimeInUTC = p2.expirationTimeInUTC
	local dateTime = if expirationTimeInUTC ~= nil then DateTime.fromIsoDate(expirationTimeInUTC) else nil
	OffersDebugLogger.logLazy(function()
		return string.format(
			"isOfferExpired parse offerId=%s expirationTimeInUTC=%s parsedUnixMillis=%s",
			tostring(p2.offerId),
			tostring(expirationTimeInUTC),
			dateTime == nil and "nil" or tostring(dateTime.UnixTimestampMillis)
		)
	end)

	if dateTime == nil then
		OffersDebugLogger.log("isOfferExpired return false (unparsed or missing expiry)")
		return false
	end

	local v5 = dateTime.UnixTimestampMillis <= DateTime.now().UnixTimestampMillis
	OffersDebugLogger.logLazy(function()
		return string.format("isOfferExpired return %s", (tostring(v5)))
	end)

	return v5
end

return isOfferExpired
