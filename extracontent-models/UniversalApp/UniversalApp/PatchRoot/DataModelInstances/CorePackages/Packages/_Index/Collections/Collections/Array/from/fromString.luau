local ParentParent = script.Parent.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(s1: string, p1: ((...any) -> ...any)?, p2) -- line: 25
	local v5 = #s1
	local t1 = table.create(v5)

	if p1 then
		for i = 1, v5 do
			if p2 ~= nil then
				t1[i] = p1(p2, string.sub(s1, i, i), i)
			else
				t1[i] = p1(string.sub(s1, i, i), i)
			end
		end

		return t1
	end

	for i = 1, v5 do
		t1[i] = string.sub(s1, i, i)
	end

	return t1
end
