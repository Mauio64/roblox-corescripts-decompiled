local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local function useGetAndSetRef(p2)
	local ref = React.useRef(p2)
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
