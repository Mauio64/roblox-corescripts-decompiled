local v = {
	{
		limitMs = 3600000,
		unitMs = 60000,
		oneKey = "TimestampOneMinuteAbbreviated",
		pluralKey = "TimestampMinutesAbbreviatedPlural",
		argName = "num_minutes"
	},
	{
		limitMs = 86400000,
		unitMs = 3600000,
		oneKey = "TimestampOneHourAbbreviated",
		pluralKey = "TimestampHoursAbbreviatedPlural",
		argName = "num_hours"
	},
	{
		limitMs = 604800000,
		unitMs = 86400000,
		oneKey = "TimestampOneDayAbbreviated",
		pluralKey = "TimestampDaysAbbreviatedPlural",
		argName = "num_days"
	},
	{
		limitMs = 2592000000,
		unitMs = 604800000,
		oneKey = "TimestampOneWeekAbbreviated",
		pluralKey = "TimestampWeeksAbbreviatedPlural",
		argName = "num_weeks"
	}
}

local function getRelativeTimestampLabel(p: number, p2: number, callback, callback2)
	local v2 = math.max(p2 - p, 0)

	if v2 < 60000 then
		return callback("Feature.Chat.Label.TimestampNow")
	end

	for _, v3 in v do
		if v2 < v3.limitMs then
			local v4 = v2 // v3.unitMs

			if v4 == 1 then
				return callback("Feature.Chat.Label." .. v3.oneKey)
			end

			return callback("Feature.Chat.Label." .. v3.pluralKey, { [v3.argName] = v4 })
		end
	end

	return callback2(p, p2)
end

return getRelativeTimestampLabel
