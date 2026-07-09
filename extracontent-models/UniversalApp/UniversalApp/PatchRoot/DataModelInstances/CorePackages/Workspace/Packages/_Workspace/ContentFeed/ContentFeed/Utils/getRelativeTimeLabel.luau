local ParentParent = script.Parent.Parent.Parent
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParent.RobloxAppLocales).Localization
local RobloxLocaleId = LocalizationService.RobloxLocaleId
local v5 = Localization.new(RobloxLocaleId)

return function(n1: number, n2: number) -- line: 15
	-- upvalues: v5 (copy), RobloxLocaleId (copy)
	local v8 = n2 - n1

	if v8 < 60000 then
		return v5:Format("Feature.ContentFeed.Timestamp.Now")
	end

	if v8 < 3600000 then
		local v9 = math.floor(v8 / 60000)

		return v5:Format("Feature.ContentFeed.Timestamp.MinutesAgo", {
			numMinutes = v9
		})
	end

	if v8 < 86400000 then
		local v10 = math.floor(v8 / 3600000)

		return v5:Format("Feature.ContentFeed.Timestamp.HoursAgo", {
			numHours = v10
		})
	end

	if v8 < 604800000 then
		local v11 = math.floor(v8 / 86400000)

		return v5:Format("Feature.ContentFeed.Timestamp.DaysAgo", {
			numDays = v11
		})
	end

	if v8 < 2419200000 then
		local v12 = math.floor(v8 / 604800000)

		return v5:Format("Feature.ContentFeed.Timestamp.WeeksAgo", {
			numWeeks = v12
		})
	end

	return `{ DateTime.fromUnixTimestampMillis(n1):FormatLocalTime("L", RobloxLocaleId) }`
end
