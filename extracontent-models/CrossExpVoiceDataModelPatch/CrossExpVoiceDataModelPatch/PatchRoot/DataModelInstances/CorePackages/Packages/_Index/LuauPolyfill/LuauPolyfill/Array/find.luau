local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1, p2: ((...any) -> ...any)) -- line: 7
	for i = 1, #p1 do
		local v5 = p1[i]

		if p2(v5, i, p1) then
			return v5
		end
	end

	return nil
end
