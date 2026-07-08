local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1, p2: ((...any) -> ...any), p3) -- line: 12
	if _G.__DEV__ then
		if typeof(p1) ~= "table" then
			error(string.format("Array.map called on %s", (typeof(p1))))
		end

		if typeof(p2) ~= "function" then
			error("callback is not a function")
		end
	end

	local v5 = #p1
	local t1 = {}
	local n1 = 1

	while n1 <= v5 do
		local v8 = p1[n1]

		if v8 ~= nil then
			t1[n1] = if p3 == nil then p2(v8, n1, p1) else p2(p3, v8, n1, p1)
		end

		n1 += 1
	end

	return t1
end
