local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local createNavigator = RoactNavigation.createNavigator
local SwitchRouter = RoactNavigation.SwitchRouter
local PreloadingSwitchView = require(Modules.AvatarExperience.Common.Components.RoactNavigation.PreloadingSwitchView)

return function(p1, p2) -- line: 38
	-- upvalues: SwitchRouter (copy), createNavigator (copy), PreloadingSwitchView (copy)
	local v9 = SwitchRouter(p1, p2)

	return createNavigator(PreloadingSwitchView, v9, p2 or {})
end
