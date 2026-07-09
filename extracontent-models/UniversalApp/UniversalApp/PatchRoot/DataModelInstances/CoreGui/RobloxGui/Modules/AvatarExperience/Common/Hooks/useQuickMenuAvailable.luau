local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local useLastInputMethod = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useLastInputMethod
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local FullView = AvatarExperienceCommon.Enums.FullView
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local function useQuickMenuAvailable() -- line: 14
	-- upvalues: useAvatarRoute (copy), React (copy), FullView (copy), useSelector (copy), getUseSelectorDeepEquals (copy), useLastInputMethod (copy), IsVRAppBuild (copy)
	local name = useAvatarRoute().opaque.name
	local v12 = React.useCallback(function(p1) -- line: 16
		-- upvalues: name (copy), FullView (copy)
		return p1.AvatarExperience.Common.FullView[name] == FullView.SceneFullView
	end, { name })
	local v13 = useSelector(v12, getUseSelectorDeepEquals())
	local v14 = useLastInputMethod() == "Gamepad"

	if v13 or (IsVRAppBuild() or not v14) then
		return false
	end

	return true
end

return useQuickMenuAvailable
