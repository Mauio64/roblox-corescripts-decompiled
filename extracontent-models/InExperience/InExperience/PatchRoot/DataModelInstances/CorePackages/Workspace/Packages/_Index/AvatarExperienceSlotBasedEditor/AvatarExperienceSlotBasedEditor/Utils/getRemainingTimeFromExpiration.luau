local function convertSecondsToTimeFrames(p: number)
	if p >= 86400 then
		return {
			value = math.ceil(p / 86400),
			unit = "days"
		}
	end

	if p >= 3600 then
		return {
			value = math.ceil(p / 3600),
			unit = "hours"
		}
	end

	return {
		value = math.ceil(p / 60),
		unit = "minutes"
	}
end

local function getRemainingTimeFromExpiration(p: string?, p2)
	if not p then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(p)

	if not dateTime then
		return nil
	end

	local v = p2 or DateTime.now()
	local v2 = math.max(dateTime.UnixTimestamp - v.UnixTimestamp, 0)

	if v2 <= 0 then
		return nil
	end

	return convertSecondsToTimeFrames(v2)
end

return getRemainingTimeFromExpiration
