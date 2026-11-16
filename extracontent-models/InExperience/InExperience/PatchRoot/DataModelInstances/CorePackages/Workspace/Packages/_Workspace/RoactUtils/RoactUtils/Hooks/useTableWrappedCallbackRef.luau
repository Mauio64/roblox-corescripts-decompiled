local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)

local function useTableWrappedCallbackRef(p)
	local ref = React.useRef(nil)

	React.useImperativeHandle(p, function()
		return ref.current
	end)

	return ref
end

return useTableWrappedCallbackRef
