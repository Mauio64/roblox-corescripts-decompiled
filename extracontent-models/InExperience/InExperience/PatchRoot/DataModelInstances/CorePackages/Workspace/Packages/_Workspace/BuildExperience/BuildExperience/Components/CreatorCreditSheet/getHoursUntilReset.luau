local function getHoursUntilReset(p: string, p2: number?)
	local dateTime = DateTime.fromIsoDate(p)

	if dateTime == nil then
		return nil
	end

	local v = p2 or DateTime.now().UnixTimestamp
	return (math.max(0, (math.ceil((dateTime.UnixTimestamp - v) / 3600))))
end

return getHoursUntilReset
