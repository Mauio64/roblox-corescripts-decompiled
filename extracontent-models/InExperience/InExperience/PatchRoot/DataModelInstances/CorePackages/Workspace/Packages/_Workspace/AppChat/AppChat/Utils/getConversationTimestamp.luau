local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("AppChat").Parent

local v = require(parent.Time)
v = v.DateTime
local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization

local RobloxLocaleId = LocalizationService.RobloxLocaleId
local v2 = Localization.new(RobloxLocaleId)

return function(object)
	local v3 = DateTime.now().UnixTimestamp - object.dateTime.UnixTimestamp

	if v3 < 60 then
		return v2:Format("Feature.Chat.Label.TimestampNow")
	end

	if v3 < 3600 then
		local num_minutes = math.floor(v3 / 60)

		if num_minutes == 1 then
			return v2:Format("Feature.Chat.Label.TimestampOneMinuteAbbreviated")
		end

		return v2:Format("Feature.Chat.Label.TimestampMinutesAbbreviatedPlural", {
			num_minutes = num_minutes
		})
	elseif v3 < 86400 then
		local num_hours = math.floor(v3 / 3600)

		if num_hours == 1 then
			return v2:Format("Feature.Chat.Label.TimestampOneHourAbbreviated")
		end

		return v2:Format("Feature.Chat.Label.TimestampHoursAbbreviatedPlural", {
			num_hours = num_hours
		})
	elseif v3 < 604800 then
		local num_days = math.floor(v3 / 86400)

		if num_days == 1 then
			return v2:Format("Feature.Chat.Label.TimestampOneDayAbbreviated")
		end

		return v2:Format("Feature.Chat.Label.TimestampDaysAbbreviatedPlural", {
			num_days = num_days
		})
	else
		if not (v3 < 2592000) then
			return object:Format("ll")
		end

		local num_weeks = math.floor(v3 / 604800)

		if num_weeks == 1 then
			return v2:Format("Feature.Chat.Label.TimestampOneWeekAbbreviated")
		end

		return v2:Format("Feature.Chat.Label.TimestampWeeksAbbreviatedPlural", {
			num_weeks = num_weeks
		})
	end
end
