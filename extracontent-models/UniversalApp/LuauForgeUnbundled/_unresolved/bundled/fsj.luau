return function(p2, value, p3)
	local v5 = tonumber(p3, 10)
	local v6 = tostring(v5) == tostring((0 / 0)) and 14
		or math.floor(math.max(0, v5 - DateTime.now().UnixTimestampMillis) / 86400000)

	value = v6 <= 1 and p2 or value

	local v7 = value:gsub("{days}", v6):gsub("{boldStart}", "<b>"):gsub("{boldEnd}", "</b>")

	if v6 < 1 then
		v7 = v7:gsub("1", "&lt; 1")
	end

	return v7
end
