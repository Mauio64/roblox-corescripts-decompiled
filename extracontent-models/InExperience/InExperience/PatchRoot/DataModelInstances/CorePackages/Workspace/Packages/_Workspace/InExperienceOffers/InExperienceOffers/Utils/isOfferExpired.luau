local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")

local OffersDebugLogger = require(InExperienceOffers.Internal.OffersDebugLogger)
require(InExperienceOffers.Types)

local function isOfferExpired(p)
	local expirationTimeInUTC = p.expirationTimeInUTC
	local dateTime

	if expirationTimeInUTC == nil then
		dateTime = nil
	else
		dateTime = DateTime.fromIsoDate(expirationTimeInUTC)
	end

	OffersDebugLogger.logLazy(function()
		return string.format(
			"isOfferExpired parse offerId=%s expirationTimeInUTC=%s parsedUnixMillis=%s",
			tostring(p.offerId),
			tostring(expirationTimeInUTC),
			dateTime == nil and "nil" or tostring(dateTime.UnixTimestampMillis)
		)
	end)

	if dateTime == nil then
		OffersDebugLogger.log("isOfferExpired return false (unparsed or missing expiry)")
		return false
	end

	local selected = dateTime.UnixTimestampMillis <= DateTime.now().UnixTimestampMillis
	OffersDebugLogger.logLazy(function()
		return string.format("isOfferExpired return %s", (tostring(selected)))
	end)

	return selected
end

return isOfferExpired
