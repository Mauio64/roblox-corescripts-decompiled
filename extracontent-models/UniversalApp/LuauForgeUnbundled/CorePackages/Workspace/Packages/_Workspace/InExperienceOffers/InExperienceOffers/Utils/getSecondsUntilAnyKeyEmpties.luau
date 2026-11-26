local OffersDebugLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Internal/OffersDebugLogger")
local OfferStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Enums/OfferStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local function secondsUntilExpiry(p2, p3)
	if p2.offerStatus ~= OfferStatus.Available then
		return nil
	end

	local expirationTimeInUTC = p2.expirationTimeInUTC
	local dateTime = if expirationTimeInUTC ~= nil then DateTime.fromIsoDate(expirationTimeInUTC) else nil

	if dateTime == nil then
		return nil
	end

	local v5 = (dateTime.UnixTimestampMillis - p3) / 1000

	if v5 > 0 then
		return v5
	end

	return nil
end

local function keyEmptiesInSeconds(item, unixTimestampMillis)
	local v5 = nil

	for k, item2 in item do
		local v6

		if item2.offerStatus == OfferStatus.Available then
			local expirationTimeInUTC = item2.expirationTimeInUTC
			local dateTime = if expirationTimeInUTC ~= nil then DateTime.fromIsoDate(expirationTimeInUTC) else nil

			if dateTime ~= nil then
				v6 = (dateTime.UnixTimestampMillis - unixTimestampMillis) / 1000

				if not (v6 > 0) then
					v6 = nil
				end
			end
		end

		if v6 ~= nil and (v5 == nil or v5 < v6) then
			v5 = v6
		end
	end

	return v5
end

local function getSecondsUntilAnyKeyEmpties(items)
	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	local secondsUntilAnyKeyEmpties = nil

	for k, item in items do
		local v5 = keyEmptiesInSeconds(item, unixTimestampMillis)

		if v5 ~= nil and (secondsUntilAnyKeyEmpties == nil or v5 < secondsUntilAnyKeyEmpties) then
			secondsUntilAnyKeyEmpties = v5
		end
	end

	OffersDebugLogger.logLazy(function()
		return string.format(
			"getSecondsUntilAnyKeyEmpties return %s",
			(tostring(secondsUntilAnyKeyEmpties))
		)
	end)

	return secondsUntilAnyKeyEmpties
end

return getSecondsUntilAnyKeyEmpties
