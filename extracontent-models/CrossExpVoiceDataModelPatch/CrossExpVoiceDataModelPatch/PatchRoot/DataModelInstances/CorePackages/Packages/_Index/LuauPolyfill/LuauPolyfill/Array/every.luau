local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1, p2: ((...any) -> ...any), p3) -- line: 11
	if _G.__DEV__ then
		if typeof(p1) ~= "table" then
			error(string.format("Array.every called on %s", (typeof(p1))))
		end

		if typeof(p2) ~= "function" then
			error("callback is not a function")
		end
	end

	local v5 = #p1
	local n1 = 1

	while n1 <= v5 do
		local v7 = p1[n1]

		if v7 ~= nil and not if p3 == nil then p2(v7, n1, p1) else p2(p3, v7, n1, p1) then
			return false
		end

		n1 += 1
	end

	return true
end
