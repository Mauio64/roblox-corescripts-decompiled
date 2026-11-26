local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local function useTableWrappedCallbackRef(p2)
	local ref = React.useRef(nil)

	React.useImperativeHandle(p2, function()
		return ref.current
	end)

	return ref
end

return useTableWrappedCallbackRef
