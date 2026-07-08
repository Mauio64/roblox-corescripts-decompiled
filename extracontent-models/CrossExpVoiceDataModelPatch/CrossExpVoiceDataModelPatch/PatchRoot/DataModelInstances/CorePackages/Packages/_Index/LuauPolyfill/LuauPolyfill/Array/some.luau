local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1, p2: ((...any) -> ...any), p3) -- line: 13
	if typeof(p1) ~= "table" then
		error(string.format("Array.some called on %s", (typeof(p1))))
	end

	if typeof(p2) ~= "function" then
		error("callback is not a function")
	end

	for v5, v6 in p1 do
		if p3 == nil then
			if v6 == nil or not p2(v6, v5, p1) then
				continue
			end

			return true
		end

		if v6 ~= nil and p2(p3, v6, v5, p1) then
			return true
		end
	end

	return false
end
