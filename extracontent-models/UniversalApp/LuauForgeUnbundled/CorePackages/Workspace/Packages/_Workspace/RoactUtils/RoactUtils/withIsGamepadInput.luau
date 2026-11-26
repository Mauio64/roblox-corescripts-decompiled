local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/Dash")
local useIsGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks/useIsGamepad")

local function withIsGamepadInput(p2)
	return function(p3)
		local v5 = useIsGamepad()
		return React.createElement(p2, Dash.join(p3, { isGamepadInput = v5 }))
	end
end

return withIsGamepadInput
