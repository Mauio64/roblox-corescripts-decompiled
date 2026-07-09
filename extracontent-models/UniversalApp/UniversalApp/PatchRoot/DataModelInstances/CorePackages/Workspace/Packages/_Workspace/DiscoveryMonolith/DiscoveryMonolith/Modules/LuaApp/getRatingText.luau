return function(n1: number?, n2: number?) -- line: 3
	local s1 = "--"
	local v4 = (not n1 or not (n1 >= 0)) and 0 or n1
	local v5 = (not n2 or not (n2 >= 0)) and 0 or n2

	if v4 + v5 > 0 then
		s1 = tostring((math.floor(v4 / (v4 + v5) * 100 + 0.5))) .. "%"
	end

	return s1
end
