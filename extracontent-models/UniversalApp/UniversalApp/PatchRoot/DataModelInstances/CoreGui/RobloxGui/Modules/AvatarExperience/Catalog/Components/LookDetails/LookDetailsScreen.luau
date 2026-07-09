local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LookDetailsPeekView = require(Modules.AvatarExperience.Catalog.Components.LookDetails.LookDetailsPeekView)

return require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)(LookDetailsPeekView)
