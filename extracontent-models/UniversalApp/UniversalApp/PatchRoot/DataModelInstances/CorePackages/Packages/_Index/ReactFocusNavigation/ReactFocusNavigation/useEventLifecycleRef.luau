local parent = script.Parent.Parent
local React = require(parent.React)

local function useEventLifecycleRef(callback, callback2)
	local ref = React.useRef(nil)
	return (React.useCallback(function(current)
		if ref.current and callback2 then
			callback2(ref.current)
		end

		if current then
			callback(current)
		end

		ref.current = current
	end, { callback, callback2 }))
end

return useEventLifecycleRef
