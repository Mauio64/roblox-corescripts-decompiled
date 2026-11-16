local Responsive = script:FindFirstAncestor("Responsive")
local parent = Responsive.Parent
local React = require(parent.React)
local InputMode = require(Responsive.InputMode)

local function usePreferredInput()
	local state, setState = React.useState(InputMode.preferred)
	React.useEffect(function()
		setState(InputMode.preferred)
		local v = InputMode.connect(function()
			setState(InputMode.preferred)
		end)
		return function()
			v:disconnect()
		end
	end, {})
	return state or ""
end

return usePreferredInput
