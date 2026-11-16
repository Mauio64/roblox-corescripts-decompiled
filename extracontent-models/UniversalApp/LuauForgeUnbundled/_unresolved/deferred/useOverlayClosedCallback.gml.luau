local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useLastInputMethod = require("@luauforge/bundled/eeo").useLastInputMethod

local function useOverlayClosedCallback()
	local name = useAvatarRoute().opaque.name
	local v5 = useLastInputMethod() == "Gamepad"
	return (React.useCallback(function()
		logOnOverlayClosed(name, v5)
	end, { v5, name }))
end

return useOverlayClosedCallback
