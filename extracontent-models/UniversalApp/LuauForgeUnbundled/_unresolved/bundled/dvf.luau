return function(p2, p3)
	local v5 = not (p2 and p2 >= 0) and 0 or p2
	local v6 = not (p3 and p3 >= 0) and 0 or p3
	return not (v5 + v6 > 0) and "--" or tostring((math.floor(v5 / (v5 + v6) * 100 + 0.5))) .. "%"
end
