local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")

local OffersDebugLogger = require(InExperienceOffers.Internal.OffersDebugLogger)
local FeatureKey = require(InExperienceOffers.Enums.FeatureKey)
local OfferStatus = require(InExperienceOffers.Enums.OfferStatus)
require(InExperienceOffers.Types)

local function getSecondsUntilNextExpiration(p)
	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	local v = nil

	local v2 = p[FeatureKey.RobloxShop]

	if v2 == nil then
		return nil
	end

	for _, v3 in v2 do
		if v3.offerStatus ~= OfferStatus.Available then
			continue
		end

		local expirationTimeInUTC = v3.expirationTimeInUTC
		local dateTime

		if expirationTimeInUTC == nil then
			dateTime = nil
		else
			dateTime = DateTime.fromIsoDate(expirationTimeInUTC)
		end

		OffersDebugLogger.logLazy(function()
			return string.format(
				"getSecondsUntilNextExpiration parse offerId=%s expirationTimeInUTC=%s parsedUnixMillis=%s",
				tostring(v3.offerId),
				tostring(expirationTimeInUTC),
				dateTime == nil and "nil" or tostring(dateTime.UnixTimestampMillis)
			)
		end)

		if dateTime == nil then
			continue
		end

		local v4 = (dateTime.UnixTimestampMillis - unixTimestampMillis) / 1000

		if v4 > 0 and (v == nil or v < v4) then
			v = v4
		end
	end

	OffersDebugLogger.logLazy(function()
		return string.format("getSecondsUntilNextExpiration return %s", (tostring(v)))
	end)

	return v
end

return getSecondsUntilNextExpiration
