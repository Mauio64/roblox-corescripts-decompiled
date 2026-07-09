local function convertSecondsToTimeFrames(n1: number) -- line: 26
	if n1 >= 86400 then
		return {
			unit = "days",
			value = math.ceil(n1 / 86400)
		}
	end

	if n1 >= 3600 then
		return {
			unit = "hours",
			value = math.ceil(n1 / 3600)
		}
	end

	return {
		unit = "minutes",
		value = math.ceil(n1 / 60)
	}
end
local function getRemainingTimeFromExpiration(s1: string?, p1) -- line: 36
	-- upvalues: convertSecondsToTimeFrames (copy)
	if not s1 then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(s1)

	if not dateTime then
		return nil
	end

	local v7 = p1 or DateTime.now()
	local v8 = math.max(dateTime.UnixTimestamp - v7.UnixTimestamp, 0)

	if v8 <= 0 then
		return nil
	end

	return (convertSecondsToTimeFrames(v8))
end

return getRemainingTimeFromExpiration
