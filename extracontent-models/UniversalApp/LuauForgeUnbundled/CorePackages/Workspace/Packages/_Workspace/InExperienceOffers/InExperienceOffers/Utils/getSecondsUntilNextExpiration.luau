local OffersDebugLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Internal/OffersDebugLogger")
local FeatureKey = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Enums/FeatureKey")
local OfferStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Enums/OfferStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local function getSecondsUntilNextExpiration(p2)
	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	local v5 = nil

	local v6 = p2[FeatureKey.RobloxShop]

	if v6 == nil then
		return nil
	end

	for k, v7 in v6 do
		if v7.offerStatus ~= OfferStatus.Available then
			continue
		end

		local expirationTimeInUTC = v7.expirationTimeInUTC
		local dateTime = if expirationTimeInUTC ~= nil then DateTime.fromIsoDate(expirationTimeInUTC) else nil
		OffersDebugLogger.logLazy(function()
			return string.format(
				"getSecondsUntilNextExpiration parse offerId=%s expirationTimeInUTC=%s parsedUnixMillis=%s",
				tostring(v7.offerId),
				tostring(expirationTimeInUTC),
				dateTime == nil and "nil" or tostring(dateTime.UnixTimestampMillis)
			)
		end)

		if dateTime == nil then
			continue
		end

		local v9 = (dateTime.UnixTimestampMillis - unixTimestampMillis) / 1000

		if v9 > 0 and (v5 == nil or v5 < v9) then
			v5 = v9
		end
	end

	OffersDebugLogger.logLazy(function()
		return string.format("getSecondsUntilNextExpiration return %s", (tostring(v5)))
	end)

	return v5
end

return getSecondsUntilNextExpiration
