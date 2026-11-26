local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local useLastInputMethod = require("@luauforge/bundled/ehL").useLastInputMethod

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local fullView = AvatarExperienceCommon.Enums.FullView
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local function useQuickMenuAvailable(): boolean
	local name = useAvatarRoute().opaque.name
	local v6 = useSelector(React.useCallback(function(p2): boolean
		return p2.AvatarExperience.Common.FullView[name] == fullView.SceneFullView
	end, { name }), getUseSelectorDeepEquals())
	local v7 = useLastInputMethod() == "Gamepad"

	if v6 or isVRAppBuild() or not v7 then
		return false
	end

	return true
end

return useQuickMenuAvailable
