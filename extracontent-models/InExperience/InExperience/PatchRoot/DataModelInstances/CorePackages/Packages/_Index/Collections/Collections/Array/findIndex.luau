local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1, p2: ((...any) -> ...any)) -- line: 22
	for i = 1, #p1 do
		if p2(p1[i], i, p1) then
			return i
		end
	end

	return -1
end
