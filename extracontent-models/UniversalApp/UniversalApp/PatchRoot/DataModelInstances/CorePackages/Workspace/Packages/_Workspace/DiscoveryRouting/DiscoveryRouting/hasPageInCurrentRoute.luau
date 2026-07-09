return function(p1, p2, b1: boolean?) -- line: 1
	if not p1 then
		return false
	end

	local v4 = #p1

	if b1 then
		v4 -= 1
	end

	for i = 1, v4 do
		if p2 == p1[i].name then
			return true
		end
	end

	return false
end
