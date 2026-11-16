local function getHoursUntilReset(p2, p3)
	local dateTime = DateTime.fromIsoDate(p2)

	if dateTime == nil then
		return nil
	end

	local v5 = p3 or DateTime.now().UnixTimestamp
	return (math.max(0, (math.ceil((dateTime.UnixTimestamp - v5) / 3600))))
end

return getHoursUntilReset
