local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useLazyRef(p1: ((...any) -> ...any)) -- line: 21
	-- upvalues: React (copy)
	local v5 = React.useRef(nil)

	if v5.current == nil then
		v5.current = p1()
	end

	assert(v5.current ~= nil, "Ref must be defined after initialization function is called")

	return v5
end

return useLazyRef
