local function getLocalDateKey(p2)
	local localTime = DateTime.fromUnixTimestampMillis(p2):ToLocalTime()
	return localTime.Year * 10000 + localTime.Month * 100 + localTime.Day
end

local function getLocalDayStartMs(p2)
	local localTime = DateTime.fromUnixTimestampMillis(p2):ToLocalTime()
	local v5 = localTime.Year * 10000 + localTime.Month * 100 + localTime.Day

	local localDayStartMs = p2 - 172800000
	local v6 = p2 + 86400000

	while localDayStartMs < v6 do
		local v7 = math.floor((localDayStartMs + v6) / 2)
		local localTime2 = DateTime.fromUnixTimestampMillis(v7):ToLocalTime()

		if localTime2.Year * 10000 + localTime2.Month * 100 + localTime2.Day < v5 then
			localDayStartMs = v7 + 1
		else
			v6 = v7
		end
	end

	return localDayStartMs
end

return {
	getLocalDayStartMs = getLocalDayStartMs,
	getNextLocalMidnightMs = function(p2)
		return getLocalDayStartMs(getLocalDayStartMs(p2) + 129600000)
	end
}
