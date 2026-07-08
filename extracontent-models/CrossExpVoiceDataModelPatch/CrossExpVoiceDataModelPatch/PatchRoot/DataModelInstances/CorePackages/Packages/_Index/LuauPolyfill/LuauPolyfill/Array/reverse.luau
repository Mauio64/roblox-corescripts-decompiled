local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1) -- line: 7
	local v3 = #p1
	local n1 = 1

	while n1 < v3 do
		local v5 = p1[v3]
		local v6 = p1[n1]

		p1[n1] = v5
		p1[v3] = v6
		n1 += 1
		v3 -= 1
	end

	return p1
end
