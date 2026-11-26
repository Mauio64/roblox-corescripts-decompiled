local LocalizationService = game:GetService("LocalizationService")
local localization = require("@luauforge/deferred/eaR").Localization

local robloxLocaleId = LocalizationService.RobloxLocaleId
local v5 = localization.new(robloxLocaleId)

return function(p2, p3)
	local v6 = p3 - p2

	if v6 < 60000 then
		return v5:Format("Feature.ContentFeed.Timestamp.Now")
	end

	if v6 < 3600000 then
		return v5:Format("Feature.ContentFeed.Timestamp.MinutesAgo", {
			numMinutes = math.floor(v6 / 60000)
		})
	end

	if v6 < 86400000 then
		return v5:Format("Feature.ContentFeed.Timestamp.HoursAgo", {
			numHours = math.floor(v6 / 3600000)
		})
	end

	if v6 < 604800000 then
		return v5:Format("Feature.ContentFeed.Timestamp.DaysAgo", {
			numDays = math.floor(v6 / 86400000)
		})
	end

	if v6 < 2419200000 then
		return v5:Format("Feature.ContentFeed.Timestamp.WeeksAgo", {
			numWeeks = math.floor(v6 / 604800000)
		})
	end

	return `{DateTime.fromUnixTimestampMillis(p2):FormatLocalTime("L", robloxLocaleId)}`
end
