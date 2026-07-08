local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1, p2, n1: number?) -- line: 12
	local v5 = n1 or 1
	local v6 = #p1

	if v5 < 1 then
		v5 = math.max(v6 - math.abs(v5), 1)
	end

	for i = v5, v6 do
		if p2 == p1[i] then
			return i
		end
	end

	return -1
end
