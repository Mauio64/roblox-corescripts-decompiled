local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local createAvatarExperienceStackNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.createAvatarExperienceStackNavigator)
local buildMainStackConfigTable = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.buildMainStackConfigTable)

local function makeAppRouterMainStackNavigator(p1) -- line: 20
	-- upvalues: buildMainStackConfigTable (copy), createAvatarExperienceStackNavigator (copy), RoactNavigation (copy)
	local v8 = buildMainStackConfigTable(p1)

	return (createAvatarExperienceStackNavigator(v8, {
		mode = RoactNavigation.StackPresentationStyle.Overlay,
		defaultNavigationOptions = {
			overlayEnabled = true,
			overlayTransparency = 1,
			absorbInput = false,
			renderUnderlyingPage = true
		}
	}))
end

return makeAppRouterMainStackNavigator
