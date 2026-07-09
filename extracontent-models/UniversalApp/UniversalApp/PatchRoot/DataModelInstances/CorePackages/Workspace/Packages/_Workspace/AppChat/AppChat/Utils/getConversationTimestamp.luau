local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("AppChat").Parent
local _ = require(Parent.Time).DateTime
local Localization = require(Parent.RobloxAppLocales).Localization
local RobloxLocaleId = LocalizationService.RobloxLocaleId
local v6 = Localization.new(RobloxLocaleId)

return function(p1) -- line: 20
	-- upvalues: v6 (copy)
	local v8 = DateTime.now().UnixTimestamp - p1.dateTime.UnixTimestamp

	if v8 < 60 then
		return v6:Format("Feature.Chat.Label.TimestampNow")
	end

	if v8 < 3600 then
		local v9 = math.floor(v8 / 60)

		if v9 == 1 then
			return v6:Format("Feature.Chat.Label.TimestampOneMinuteAbbreviated")
		end

		return v6:Format("Feature.Chat.Label.TimestampMinutesAbbreviatedPlural", {
			num_minutes = v9
		})
	end

	if v8 < 86400 then
		local v10 = math.floor(v8 / 3600)

		if v10 == 1 then
			return v6:Format("Feature.Chat.Label.TimestampOneHourAbbreviated")
		end

		return v6:Format("Feature.Chat.Label.TimestampHoursAbbreviatedPlural", {
			num_hours = v10
		})
	end

	if v8 < 604800 then
		local v11 = math.floor(v8 / 86400)

		if v11 == 1 then
			return v6:Format("Feature.Chat.Label.TimestampOneDayAbbreviated")
		end

		return v6:Format("Feature.Chat.Label.TimestampDaysAbbreviatedPlural", {
			num_days = v11
		})
	end

	if v8 < 2592000 then
		local v12 = math.floor(v8 / 604800)

		if v12 == 1 then
			return v6:Format("Feature.Chat.Label.TimestampOneWeekAbbreviated")
		end

		return v6:Format("Feature.Chat.Label.TimestampWeeksAbbreviatedPlural", {
			num_weeks = v12
		})
	end

	return p1:Format("ll")
end
