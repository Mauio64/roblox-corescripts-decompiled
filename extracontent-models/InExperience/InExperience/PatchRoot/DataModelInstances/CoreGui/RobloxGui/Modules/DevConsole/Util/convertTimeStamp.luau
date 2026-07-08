local v1 = game:DefineFastFlag("DevConsoleFixTimestampDST", false)

local function numberWithZero(p1) -- line: 4
	return (not (p1 < 10) and "" or "0") .. p1
end
local function convertTimeStamp(p2) -- line: 8
	-- upvalues: v1 (copy)
	local hour, min, sec

	if v1 then
		local v6 = os.date("*t", p2)

		hour = v6.hour
		min = v6.min
		sec = v6.sec
	else
		local v10 = math.floor(p2 - os.time() + tick()) % 86400

		hour = math.floor(v10 / 3600)

		local v11 = v10 - hour * 3600

		min = math.floor(v11 / 60)
		sec = v11 - min * 60
	end

	local v12 = (not (hour < 10) and "" or "0") .. hour
	local v13 = (not (min < 10) and "" or "0") .. min
	local v14 = (not (sec < 10) and "" or "0") .. sec

	return string.format("%s:%s:%s", v12, v13, v14)
end

return convertTimeStamp
