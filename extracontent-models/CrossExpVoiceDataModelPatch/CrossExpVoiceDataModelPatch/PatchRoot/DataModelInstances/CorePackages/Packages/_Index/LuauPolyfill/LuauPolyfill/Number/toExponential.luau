return function(value, value2: number?)
	local v = typeof(value) == "string" and (tonumber(value) or (0 / 0)) or value

	if typeof(v) ~= "number" then
		return "nan"
	end

	if value2 ~= nil then
		if typeof(value2) ~= "number" then
			error("TypeError: fractionDigits must be a number between 0 and 100")
		end

		if value2 < 0 or value2 > 100 then
			error("RangeError: fractionDigits must be between 0 and 100")
		end
	end

	local v2 = value2 == nil and "%e" or "%." .. tostring(value2) .. "e"

	return (string.format(v2, v):gsub("%+0", "+"):gsub("%-0", "-"):gsub("0*e", "e"))
end
