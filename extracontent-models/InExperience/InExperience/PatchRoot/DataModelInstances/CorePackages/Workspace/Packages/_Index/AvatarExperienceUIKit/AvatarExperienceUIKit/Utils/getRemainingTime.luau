local function convertSecondsToTimeFrames(secondsRemaining: number)
	if secondsRemaining >= 86400 then
		return {
			value = math.floor(secondsRemaining / 86400),
			unit = "days",
			secondsRemaining = secondsRemaining
		}
	end

	if secondsRemaining >= 3600 then
		return {
			value = math.floor(secondsRemaining / 3600),
			unit = "hours",
			secondsRemaining = secondsRemaining
		}
	end

	if secondsRemaining >= 60 then
		return {
			value = math.floor(secondsRemaining / 60),
			unit = "minutes",
			secondsRemaining = secondsRemaining
		}
	end

	return {
		value = math.floor(secondsRemaining),
		unit = "seconds",
		secondsRemaining = secondsRemaining
	}
end

local function getRemainingTime(p: string?, p2)
	if not p then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(p)

	if not dateTime then
		return nil
	end

	local v = p2 or DateTime.now()
	local secondsRemaining = dateTime.UnixTimestamp - v.UnixTimestamp

	if secondsRemaining <= 0 then
		return { value = -1, unit = "seconds", secondsRemaining = secondsRemaining }
	end

	return convertSecondsToTimeFrames(secondsRemaining)
end

return getRemainingTime
