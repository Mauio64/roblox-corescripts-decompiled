local function convertSecondsToTimeFrames(p2)
	if p2 >= 86400 then
		return {
			value = math.ceil(p2 / 86400),
			unit = "days"
		}
	end

	if p2 >= 3600 then
		return {
			value = math.ceil(p2 / 3600),
			unit = "hours"
		}
	end

	return {
		value = math.ceil(p2 / 60),
		unit = "minutes"
	}
end

local function getRemainingTimeFromExpiration(p2, p3)
	if not p2 then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(p2)

	if not dateTime then
		return nil
	end

	local v5 = p3 or DateTime.now()
	local v6 = math.max(dateTime.UnixTimestamp - v5.UnixTimestamp, 0)

	if v6 <= 0 then
		return nil
	end

	return convertSecondsToTimeFrames(v6)
end

return getRemainingTimeFromExpiration
