local parent = script:FindFirstAncestor("Responsive").Parent
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local function useIsInFullScreen()
	local v = useRoactService(RoactServiceTags.AppUserGameSettings)
	local state, setState = React.useState(v:InFullScreen())

	React.useEffect(function()
		setState(v:InFullScreen())
		local fullscreenChangedConnection = v.FullscreenChanged:Connect(function(flag: boolean)
			setState(flag)
		end)

		return function()
			fullscreenChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useIsInFullScreen
