local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/React")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/RoactServiceTags")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/RobloxAppHooks").useRoactService

local function useIsInFullScreen()
	local v5 = useRoactService(RoactServiceTags.AppUserGameSettings)
	local state, setState = React.useState(v5:InFullScreen())

	React.useEffect(function()
		setState(v5:InFullScreen())
		local fullscreenChangedConnection = v5.FullscreenChanged:Connect(function(p2)
			setState(p2)
		end)

		return function()
			fullscreenChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useIsInFullScreen
