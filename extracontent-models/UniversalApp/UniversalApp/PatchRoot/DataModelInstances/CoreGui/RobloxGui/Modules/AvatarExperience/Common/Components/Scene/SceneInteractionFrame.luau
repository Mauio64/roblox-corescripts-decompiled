local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SharedInteractionFrame = require(Modules.AvatarExperience.Common.Components.SharedInteractionFrame)

return (require(Modules.AvatarExperience.Common.Context.wrapWithSceneInteractionCallbacks)(SharedInteractionFrame))
