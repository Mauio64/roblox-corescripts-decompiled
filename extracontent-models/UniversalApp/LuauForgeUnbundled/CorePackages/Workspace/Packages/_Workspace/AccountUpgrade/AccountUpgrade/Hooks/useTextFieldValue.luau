local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")

local function useTextFieldValue(value, callback)
	local state, setState = React.useState(value or "")
	local ref = React.useRef(state)

	return {
		value = state,
		valueRef = ref,
		onChanged = React.useCallback(function(current)
			ref.current = current
			setState(current)
			callback(current)
		end, { callback })
	}
end

return useTextFieldValue
