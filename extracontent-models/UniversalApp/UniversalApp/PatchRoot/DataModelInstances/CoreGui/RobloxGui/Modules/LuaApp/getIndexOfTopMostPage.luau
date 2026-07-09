return function(p1, p2) -- line: 1
	local v3 = p2[#p2]

	if not v3 then
		return
	end

	for i = #v3, 1, -1 do
		if p1 == v3[i].name then
			return i
		end
	end
end
