local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")

local OffersDebugLogger = require(InExperienceOffers.Internal.OffersDebugLogger)
local OfferStatus = require(InExperienceOffers.Enums.OfferStatus)
require(InExperienceOffers.Types)

local function secondsUntilExpiry(item, p: number) -- 1 equivalent call inferred from this helper
	if item.offerStatus ~= OfferStatus.Available then
		return nil
	end

	local expirationTimeInUTC = item.expirationTimeInUTC
	local dateTime

	if expirationTimeInUTC ~= nil then
		dateTime = DateTime.fromIsoDate(expirationTimeInUTC)
	end

	if dateTime == nil then
		return nil
	end

	local v = (dateTime.UnixTimestampMillis - p) / 1000
	return if v > 0 then v else nil
end

local function keyEmptiesInSeconds(item, unixTimestampMillis: number)
	local v = nil

	for _, item2 in item do
		local v2 = secondsUntilExpiry(item2, unixTimestampMillis) -- inferred equivalent call

		if v2 ~= nil and (v == nil or v < v2) then
			v = v2
		end
	end

	return v
end

local function getSecondsUntilAnyKeyEmpties(items)
	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	local secondsUntilAnyKeyEmpties = nil

	for _, item in items do
		local v = keyEmptiesInSeconds(item, unixTimestampMillis)

		if v ~= nil and (secondsUntilAnyKeyEmpties == nil or v < secondsUntilAnyKeyEmpties) then
			secondsUntilAnyKeyEmpties = v
		end
	end

	OffersDebugLogger.logLazy(function()
		return string.format("getSecondsUntilAnyKeyEmpties return %s", (tostring(secondsUntilAnyKeyEmpties)))
	end)

	return secondsUntilAnyKeyEmpties
end

return getSecondsUntilAnyKeyEmpties
