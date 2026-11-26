local function convertSecondsToTimeFrames(p2)
	if p2 >= 86400 then
		return {
			value = math.floor(p2 / 86400),
			unit = "days",
			secondsRemaining = p2
		}
	end

	if p2 >= 3600 then
		return {
			value = math.floor(p2 / 3600),
			unit = "hours",
			secondsRemaining = p2
		}
	end

	if p2 >= 60 then
		return {
			value = math.floor(p2 / 60),
			unit = "minutes",
			secondsRemaining = p2
		}
	end

	return { value = math.floor(p2), unit = "seconds", secondsRemaining = p2 }
end

local function getRemainingTime(p2, p3)
	if not p2 then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(p2)

	if not dateTime then
		return nil
	end

	local v5 = p3 or DateTime.now()
	local v6 = dateTime.UnixTimestamp - v5.UnixTimestamp

	if v6 <= 0 then
		return { value = -1, unit = "seconds", secondsRemaining = v6 }
	end

	return convertSecondsToTimeFrames(v6)
end

return getRemainingTime
