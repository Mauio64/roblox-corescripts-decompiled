local function convertSecondsToTimeFrames(n1: number) -- line: 33
	if n1 >= 86400 then
		return {
			unit = "days",
			value = math.floor(n1 / 86400),
			secondsRemaining = n1
		}
	end

	if n1 >= 3600 then
		return {
			unit = "hours",
			value = math.floor(n1 / 3600),
			secondsRemaining = n1
		}
	end

	if n1 >= 60 then
		return {
			unit = "minutes",
			value = math.floor(n1 / 60),
			secondsRemaining = n1
		}
	end

	return {
		unit = "seconds",
		value = math.floor(n1),
		secondsRemaining = n1
	}
end
local function getRemainingTime(s1: string?, p1) -- line: 61
	-- upvalues: convertSecondsToTimeFrames (copy)
	if not s1 then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(s1)

	if not dateTime then
		return nil
	end

	local v7 = p1 or DateTime.now()
	local v8 = dateTime.UnixTimestamp - v7.UnixTimestamp

	if v8 <= 0 then
		return {
			value = -1,
			unit = "seconds",
			secondsRemaining = v8
		}
	end

	return (convertSecondsToTimeFrames(v8))
end

return getRemainingTime
