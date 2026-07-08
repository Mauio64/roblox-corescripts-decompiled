local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1, p2: ((...any) -> ...any), p3) -- line: 11
	if _G.__DEV__ then
		if typeof(p1) ~= "table" then
			error(string.format("Array.filter called on %s", (typeof(p1))))
		end

		if typeof(p2) ~= "function" then
			error("callback is not a function")
		end
	end

	local v5 = #p1
	local t1 = {}
	local n1 = 1

	if p3 == nil then
		for i = 1, v5 do
			local v9 = p1[i]

			if v9 ~= nil and p2(v9, i, p1) then
				t1[n1] = v9
				n1 += 1
			end
		end

		return t1
	end

	for i = 1, v5 do
		local v11 = p1[i]

		if v11 ~= nil and p2(p3, v11, i, p1) then
			t1[n1] = v11
			n1 += 1
		end
	end

	return t1
end
