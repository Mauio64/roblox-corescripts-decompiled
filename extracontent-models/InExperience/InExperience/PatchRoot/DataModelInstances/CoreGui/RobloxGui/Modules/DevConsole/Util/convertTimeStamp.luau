local defineFastFlag = game:DefineFastFlag("DevConsoleFixTimestampDST", false)

local function numberWithZero(p) -- 3 equivalent calls inferred from this helper
	return (p < 10 and "0" or "") .. p
end

local function convertTimeStamp(p)
	local v, v2, v3

	if defineFastFlag then
		local v4 = os.date("*t", p)
		v = v4.hour
		v2 = v4.min
		v3 = v4.sec
	else
		local v4 = math.floor(p - os.time() + tick()) % 86400

		v = math.floor(v4 / 3600)
		local v5 = v4 - v * 3600
		v2 = math.floor(v5 / 60)
		v3 = v5 - v2 * 60
	end

	return string.format("%s:%s:%s", numberWithZero(v), numberWithZero(v2), numberWithZero(v3)) -- inferred equivalent call
end

return convertTimeStamp
