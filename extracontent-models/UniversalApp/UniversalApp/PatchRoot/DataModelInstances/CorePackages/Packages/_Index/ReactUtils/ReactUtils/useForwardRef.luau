local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useForwardRef(p, callback)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v = React.useCallback(function(current)
		if ref2.current then
			ref2.current()
			ref2.current = nil
		end

		if current then
			ref.current = current
			ref2.current = callback(current)
		end
	end, { callback })

	React.useImperativeHandle(p, function()
		return ref.current
	end)

	return v
end

return useForwardRef
