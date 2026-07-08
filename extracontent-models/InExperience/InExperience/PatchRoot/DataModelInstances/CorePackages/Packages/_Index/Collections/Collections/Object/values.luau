local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1) -- line: 23
	if p1 == nil then
		error("cannot extract values from a nil value")
	end

	local v3 = typeof(p1)
	local t2 = nil

	if v3 == "table" then
		local t1 = {}

		for _, v in pairs(p1) do
			table.insert(t1, v)
		end

		return t1
	end

	if v3 == "string" then
		local v8 = p1:len()

		t2 = table.create(v8)

		for i = 1, v8 do
			t2[i] = p1:sub(i, i)
		end
	end

	return t2
end
