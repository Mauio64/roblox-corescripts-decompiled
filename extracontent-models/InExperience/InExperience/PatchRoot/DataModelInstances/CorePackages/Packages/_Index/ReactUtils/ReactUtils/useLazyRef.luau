local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useLazyRef(callback)
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = callback()
	end

	assert(ref.current ~= nil, "Ref must be defined after initialization function is called")
	return ref
end

return useLazyRef
