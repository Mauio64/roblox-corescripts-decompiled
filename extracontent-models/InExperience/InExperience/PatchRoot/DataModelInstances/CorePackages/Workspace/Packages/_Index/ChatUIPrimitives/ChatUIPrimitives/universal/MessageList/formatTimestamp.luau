local function formatTimestamp(p: number, p2: number?, value: string?)
	local v = math.abs(p - (p2 or DateTime.now().UnixTimestampMillis))
	local v2

	if v >= 31536000000 then
		v2 = "MMM D, YYYY, LT"
	elseif v >= 432000000 then
		v2 = "MMM D, LT"
	else
		v2 = if v >= 86400000 then "dddd LT" else "LT"
	end

	return DateTime.fromUnixTimestampMillis(p):FormatLocalTime(v2, value or "en-us")
end

return formatTimestamp
