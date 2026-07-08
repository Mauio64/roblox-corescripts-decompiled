local ParentParent = script.Parent.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1, p2: ((...any) -> ...any)?, p3) -- line: 25
	if p2 then
		local v5 = #p1
		local t1 = table.create(v5)

		for i = 1, v5 do
			if p3 ~= nil then
				t1[i] = p2(p3, p1[i], i)
			else
				t1[i] = p2(p1[i], i)
			end
		end

		return t1
	end

	return (table.clone(p1))
end
