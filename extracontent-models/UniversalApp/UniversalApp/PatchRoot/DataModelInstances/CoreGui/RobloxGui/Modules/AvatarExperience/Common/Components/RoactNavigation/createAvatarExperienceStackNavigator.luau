local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local createNavigator = RoactNavigation.createNavigator
local RobloxStackView = RoactNavigation.RobloxStackView
local RobloxAppNavigationCore = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local AvatarExperienceStackRouter = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarExperienceStackRouter)

return function(p1, p2) -- line: 19
	-- upvalues: AvatarExperienceStackRouter (copy), createNavigator (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RobloxAppNavigationCore (copy), RobloxStackView (copy)
	local v11 = AvatarExperienceStackRouter(p1, p2)

	return createNavigator(if not FFlagAXMigrateAXToGlobalAutofocus then RobloxStackView else RobloxAppNavigationCore.AppStackView, v11, p2 or {})
end
