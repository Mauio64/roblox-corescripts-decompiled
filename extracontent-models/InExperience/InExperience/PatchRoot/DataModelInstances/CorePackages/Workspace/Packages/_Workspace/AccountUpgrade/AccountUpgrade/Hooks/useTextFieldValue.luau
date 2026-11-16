local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local React = require(parent.React)

local function useTextFieldValue(value: string?, callback)
	local state, setState = React.useState(value or "")
	local ref = React.useRef(state)

	return {
		value = state,
		valueRef = ref,
		onChanged = React.useCallback(function(current: string)
			ref.current = current
			setState(current)
			callback(current)
		end, { callback })
	}
end

return useTextFieldValue
