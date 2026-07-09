local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local selectHasModerationAlert = require(Modules.AvatarExperience.Common.Selectors.selectHasModerationAlert)
local selectHasNoSharedAvatarsOnMySharedAvatars = require(Modules.AvatarExperience.Common.Selectors.selectHasNoSharedAvatarsOnMySharedAvatars)
local WidgetListModerationAlert = require(Modules.AvatarExperience.Common.Components.WidgetList.Components.WidgetListModerationAlert)
local NoSharedAvatars = require(Modules.AvatarExperience.AvatarEditor.Components.MySharedAvatars.NoSharedAvatars)
local v13 = game:DefineFastFlag("TurnOffModerationAlert", false)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function ResultsListListHeader(_) -- line: 24
	-- upvalues: useAvatarRoute (copy), useSelector (copy), v13 (copy), selectHasModerationAlert (copy), getUseSelectorDeepEquals (copy), selectHasNoSharedAvatarsOnMySharedAvatars (copy), AvatarScreen (copy), React (copy), WidgetListModerationAlert (copy), NoSharedAvatars (copy)
	local v17 = useAvatarRoute()
	local v18 = useSelector(function(p2) -- line: 27
		-- upvalues: v13 (copy), selectHasModerationAlert (copy), v17 (copy)
		if v13 then
			return false
		end

		return selectHasModerationAlert(p2, v17)
	end, getUseSelectorDeepEquals())
	local v19 = useSelector(function(p3) -- line: 33
		-- upvalues: selectHasNoSharedAvatarsOnMySharedAvatars (copy), v17 (copy)
		return selectHasNoSharedAvatarsOnMySharedAvatars(p3, v17)
	end, getUseSelectorDeepEquals())

	if v17 and (v17.opaque and v17.opaque.name == AvatarScreen.MySharedAvatars) then
		if v18 then
			return React.createElement(WidgetListModerationAlert)
		end

		if v19 then
			return React.createElement(NoSharedAvatars)
		end
	end

	return nil
end

return ResultsListListHeader
