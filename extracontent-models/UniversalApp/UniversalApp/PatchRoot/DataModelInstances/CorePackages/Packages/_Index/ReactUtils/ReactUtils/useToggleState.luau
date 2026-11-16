local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useToggleState(p)
	local state, setState = React.useState(p or false)

	return {
		enabled = state,
		enable = React.useCallback(function()
			setState(true)
		end, {}),
		disable = React.useCallback(function()
			setState(false)
		end, {}),
		toggle = React.useCallback(function()
			setState(function(p2): boolean
				return not p2
			end)
		end, {}),
		set = setState
	}
end

return useToggleState
