local LocalizationService = game:GetService("LocalizationService")

local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppLocales").Localization

local robloxLocaleId = LocalizationService.RobloxLocaleId
local v5 = localization.new(robloxLocaleId)

return function(object)
	local v6 = DateTime.now().UnixTimestamp - object.dateTime.UnixTimestamp

	if v6 < 60 then
		return v5:Format("Feature.Chat.Label.TimestampNow")
	end

	if v6 < 3600 then
		local v7 = math.floor(v6 / 60)

		if v7 == 1 then
			return v5:Format("Feature.Chat.Label.TimestampOneMinuteAbbreviated")
		end

		return v5:Format("Feature.Chat.Label.TimestampMinutesAbbreviatedPlural", {
			num_minutes = v7
		})
	elseif v6 < 86400 then
		local v7 = math.floor(v6 / 3600)

		if v7 == 1 then
			return v5:Format("Feature.Chat.Label.TimestampOneHourAbbreviated")
		end

		return v5:Format("Feature.Chat.Label.TimestampHoursAbbreviatedPlural", {
			num_hours = v7
		})
	elseif v6 < 604800 then
		local v7 = math.floor(v6 / 86400)

		if v7 == 1 then
			return v5:Format("Feature.Chat.Label.TimestampOneDayAbbreviated")
		end

		return v5:Format("Feature.Chat.Label.TimestampDaysAbbreviatedPlural", {
			num_days = v7
		})
	else
		if not (v6 < 2592000) then
			return object:Format("ll")
		end

		local v7 = math.floor(v6 / 604800)

		if v7 == 1 then
			return v5:Format("Feature.Chat.Label.TimestampOneWeekAbbreviated")
		end

		return v5:Format("Feature.Chat.Label.TimestampWeeksAbbreviatedPlural", {
			num_weeks = v7
		})
	end
end
