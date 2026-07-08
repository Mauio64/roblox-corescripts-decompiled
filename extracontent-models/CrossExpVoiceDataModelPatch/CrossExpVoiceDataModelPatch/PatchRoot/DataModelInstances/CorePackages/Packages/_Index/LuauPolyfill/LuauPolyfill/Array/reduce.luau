local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1, p2: ((...any) -> ...any), p3) -- line: 10
	if _G.__DEV__ then
		if typeof(p1) ~= "table" then
			error(string.format("Array.reduce called on %s", (typeof(p1))))
		end

		if typeof(p2) ~= "function" then
			error("callback is not a function")
		end
	end

	local v5 = #p1
	local n1 = 1

	if p3 ~= nil then
	else
		n1 = 2

		if v5 == 0 then
			error("reduce of empty array with no initial value")
		end

		p3 = p1[1]
	end

	for i = n1, v5 do
		p3 = p2(p3, p1[i], i, p1)
	end

	return p3
end
