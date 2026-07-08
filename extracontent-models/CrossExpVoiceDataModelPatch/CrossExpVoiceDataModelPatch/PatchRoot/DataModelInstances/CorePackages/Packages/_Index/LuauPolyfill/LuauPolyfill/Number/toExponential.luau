return function(p1, n1: number?) -- line: 3
	if typeof(p1) == "string" then
		p1 = tonumber(p1) or (0/0)
	end

	if typeof(p1) ~= "number" then
		return "nan"
	end

	if n1 ~= nil then
		if typeof(n1) ~= "number" then
			error("TypeError: fractionDigits must be a number between 0 and 100")
		end

		if n1 < 0 or n1 > 100 then
			error("RangeError: fractionDigits must be between 0 and 100")
		end
	end

	local v3 = if n1 ~= nil then "%." .. tostring(n1) .. "e" else "%e"

	return (string.format(v3, p1):gsub("%+0", "+"):gsub("%-0", "-"):gsub("0*e", "e"))
end
