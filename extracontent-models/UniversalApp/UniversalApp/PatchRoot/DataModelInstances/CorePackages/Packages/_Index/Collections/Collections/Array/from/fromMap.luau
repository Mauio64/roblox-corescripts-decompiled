local ParentParent = script.Parent.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1, p2: ((...any) -> ...any)?, p3) -- line: 25
	if p2 then
		local t1 = {}

		for v6, v7 in p1 do
			if p3 ~= nil then
				t1[v6] = p2(p3, v7, v6)
			else
				t1[v6] = p2(v7, v6)
			end
		end

		return t1
	end

	local t2 = {}

	for v9, v10 in p1 do
		t2[v9] = v10
	end

	return t2
end
