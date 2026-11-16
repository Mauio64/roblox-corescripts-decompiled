local function getActiveInterventionTimeoutEnd(p, p2: number)
	local timeoutDurationSeconds = p.timeoutDurationSeconds

	if timeoutDurationSeconds == nil or timeoutDurationSeconds < 0 then
		return false, nil
	end

	if timeoutDurationSeconds == 0 then
		return true, nil
	end

	local timeoutStartTime = p.timeoutStartTime
	local dateTime

	if timeoutStartTime and timeoutStartTime ~= "" then
		dateTime = DateTime.fromIsoDate(timeoutStartTime)
	end

	local v = if dateTime then dateTime.UnixTimestamp else p2
	local v2 = v + timeoutDurationSeconds

	if v2 <= p2 then
		return false, nil
	end

	return true, v2
end

return getActiveInterventionTimeoutEnd
