local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/ReactUtils")

local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")

local useEventConnection = ReactUtils.useEventConnection

local InputUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/InputUtilities")

return function()
	local state, setState = React.useState(false)

	local v5 = React.useCallback(function(p2)
		if InputUtilities.isTouchInput(p2) then
			setState(true)
		end
	end, { setState })

	local v6 = React.useCallback(function(p2)
		if InputUtilities.isTouchInput(p2) then
			setState(false)
		end
	end, { setState })

	useEventConnection(UserInputService.InputBegan, v5)
	useEventConnection(UserInputService.InputEnded, v6)

	return state
end
