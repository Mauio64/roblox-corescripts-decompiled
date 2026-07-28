local function getHoursUntilReset(s1: string, n1: number?) -- line: 3
	local dateTime = DateTime.fromIsoDate(s1)

	if dateTime == nil then
		return nil
	end

	local v5 = n1 or DateTime.now().UnixTimestamp

	return (math.max(0, (math.ceil((dateTime.UnixTimestamp - v5) / 3600))))
end

return getHoursUntilReset
