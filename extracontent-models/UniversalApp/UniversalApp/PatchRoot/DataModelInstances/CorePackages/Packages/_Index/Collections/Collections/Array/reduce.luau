local __DEV__ = _G.__DEV__
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1, p2: ((...any) -> ...any), p3) -- line: 26
	-- upvalues: __DEV__ (copy)
	if __DEV__ then
		if typeof(p1) ~= "table" then
			error(string.format("Array.reduce called on %s", (typeof(p1))))
		end

		if typeof(p2) ~= "function" then
			error("callback is not a function")
		end
	end

	local v6 = #p1
	local n1 = 1

	if p3 ~= nil then
	else
		n1 = 2

		if v6 == 0 then
			error("reduce of empty array with no initial value")
		end

		p3 = p1[1]
	end

	for i = n1, v6 do
		p3 = p2(p3, p1[i], i, p1)
	end

	return p3
end
