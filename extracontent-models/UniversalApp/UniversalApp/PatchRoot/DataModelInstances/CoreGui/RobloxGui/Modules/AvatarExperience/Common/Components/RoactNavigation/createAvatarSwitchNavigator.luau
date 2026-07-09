local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local createNavigator = RoactNavigation.createNavigator
local SwitchRouter = RoactNavigation.SwitchRouter

require(CorePackages.Workspace.Packages.Navigation)

local RobloxAppNavigationCore = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore)
local PreloadingSwitchView = require(Modules.AvatarExperience.Common.Components.RoactNavigation.PreloadingSwitchView)
local FFlagAXUsePreloadingSwitchView = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXUsePreloadingSwitchView

local function createAvatarSwitchNavigator(p1, p2) -- line: 13
	-- upvalues: SwitchRouter (copy), createNavigator (copy), FFlagAXUsePreloadingSwitchView (copy), PreloadingSwitchView (copy), RobloxAppNavigationCore (copy)
	local v12 = SwitchRouter(p1, p2)

	return createNavigator(if not FFlagAXUsePreloadingSwitchView then RobloxAppNavigationCore.AppSwitchView else PreloadingSwitchView, v12, p2)
end

return createAvatarSwitchNavigator
