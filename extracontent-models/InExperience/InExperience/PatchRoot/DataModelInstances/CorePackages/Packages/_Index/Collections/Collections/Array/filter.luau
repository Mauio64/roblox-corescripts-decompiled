local __DEV__ = _G.__DEV__
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1, p2: ((...any) -> ...any), p3) -- line: 27
	-- upvalues: __DEV__ (copy)
	if __DEV__ then
		if typeof(p1) ~= "table" then
			error(string.format("Array.filter called on %s", (typeof(p1))))
		end

		if typeof(p2) ~= "function" then
			error("callback is not a function")
		end
	end

	local v6 = #p1
	local t1 = {}
	local n1 = 1

	if p3 == nil then
		for i = 1, v6 do
			local v10 = p1[i]

			if v10 ~= nil and p2(v10, i, p1) then
				t1[n1] = v10
				n1 += 1
			end
		end

		return t1
	end

	for i = 1, v6 do
		local v12 = p1[i]

		if v12 ~= nil and p2(p3, v12, i, p1) then
			t1[n1] = v12
			n1 += 1
		end
	end

	return t1
end
