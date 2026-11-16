local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")

local function useStatefulRef(callback)
	local state, setState = React.useState(nil)
	return state, (React.useCallback(function(current)
		if typeof(callback) == "function" then
			callback(current)
		elseif typeof(callback) == "table" then
			callback.current = current
		end

		setState(current)
	end, { callback }))
end

return useStatefulRef
