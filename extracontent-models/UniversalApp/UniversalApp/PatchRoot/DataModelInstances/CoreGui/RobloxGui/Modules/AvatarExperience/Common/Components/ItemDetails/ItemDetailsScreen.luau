local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation
local ItemDetails = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemDetails)
local ItemDetails_DEPRECATED = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemDetails_DEPRECATED)

return require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)(if not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation then ItemDetails_DEPRECATED else ItemDetails)
