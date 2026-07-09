return function(p1, p2, p3) -- line: 18
	local num = tonumber(p3, 10)
	local v7 = if tostring(num) ~= tostring((0/0)) then math.floor(math.max(0, num - DateTime.now().UnixTimestampMillis) / 86400000) else 14
	local v8 = (v7 <= 1 and p1 or p2):gsub("{days}", v7):gsub("{boldStart}", "<b>"):gsub("{boldEnd}", "</b>")

	if v7 < 1 then
		v8 = v8:gsub("1", "&lt; 1")
	end

	return v8
end
