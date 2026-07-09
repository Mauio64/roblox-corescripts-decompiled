local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OutfitDetailsPeekView = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.OutfitDetailsPeekView)

return require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)(OutfitDetailsPeekView)
