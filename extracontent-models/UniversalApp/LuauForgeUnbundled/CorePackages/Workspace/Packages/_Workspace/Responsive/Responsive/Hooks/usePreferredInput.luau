local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/React")
local InputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/InputMode")

local function usePreferredInput()
	local state, setState = React.useState(InputMode.preferred)
	React.useEffect(function()
		setState(InputMode.preferred)
		local v5 = InputMode.connect(function()
			setState(InputMode.preferred)
		end)
		return function()
			v5:disconnect()
		end
	end, {})
	return state or ""
end

return usePreferredInput
