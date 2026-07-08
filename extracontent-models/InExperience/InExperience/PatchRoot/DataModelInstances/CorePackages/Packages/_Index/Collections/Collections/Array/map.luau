local __DEV__ = _G.__DEV__
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1, p2: ((...any) -> ...any), p3) -- line: 27
	-- upvalues: __DEV__ (copy)
	if __DEV__ then
		if typeof(p1) ~= "table" then
			error(string.format("Array.map called on %s", (typeof(p1))))
		end

		if typeof(p2) ~= "function" then
			error("callback is not a function")
		end
	end

	local v6 = #p1
	local t1 = {}
	local n1 = 1

	while n1 <= v6 do
		local v9 = p1[n1]

		if v9 ~= nil then
			t1[n1] = if p3 == nil then p2(v9, n1, p1) else p2(p3, v9, n1, p1)
		end

		n1 += 1
	end

	return t1
end
