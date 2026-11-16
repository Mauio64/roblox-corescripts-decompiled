local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/React")
local InputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/InputMode")

local function useLastInput()
	local state, setState = React.useState(InputMode.last)
	React.useEffect(function()
		setState(InputMode.last)
		local v5 = InputMode.connect(function()
			setState(InputMode.last)
		end)
		return function()
			v5:disconnect()
		end
	end, {})
	return state or ""
end

return useLastInput
