local Responsive = script:FindFirstAncestor("Responsive")
local parent = Responsive.Parent
local React = require(parent.React)
local InputMode = require(Responsive.InputMode)

local function useLastInput()
	local state, setState = React.useState(InputMode.last)
	React.useEffect(function()
		setState(InputMode.last)
		local v = InputMode.connect(function()
			setState(InputMode.last)
		end)
		return function()
			v:disconnect()
		end
	end, {})
	return state or ""
end

return useLastInput
