local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)

local function useGetAndSetRef(p)
	local ref = React.useRef(p)
	return React.useCallback(function()
		return ref.current
	end, {}), (React.useCallback(function(current)
		if typeof(current) == "function" then
			ref.current = current(ref.current)
		else
			ref.current = current
		end
	end, {}))
end

return useGetAndSetRef
