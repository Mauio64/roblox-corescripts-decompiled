local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarPromptDescriptors = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarPromptDescriptors)
local makeAppRouterMainStackNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.makeAppRouterMainStackNavigator)

local function buildConfigTable(p1) -- line: 22
	-- upvalues: makeAppRouterMainStackNavigator (copy), Cryo (copy), AvatarScreen (copy), AvatarPromptDescriptors (copy)
	local v11 = makeAppRouterMainStackNavigator(p1)

	return (Cryo.List.join({{
		[AvatarScreen.AvatarExperienceMainStackNavigator] = v11
	}}, AvatarPromptDescriptors))
end
local function makeAppRouterRootNavigator(p2) -- line: 33
	-- upvalues: buildConfigTable (copy), RoactNavigation (copy)
	local v13 = buildConfigTable(p2)

	return (RoactNavigation.createRobloxStackNavigator(v13, {
		mode = RoactNavigation.StackPresentationStyle.Overlay,
		defaultNavigationOptions = {
			absorbInput = false,
			overlayEnabled = true,
			overlayTransparency = 1
		}
	}))
end

return makeAppRouterRootNavigator
