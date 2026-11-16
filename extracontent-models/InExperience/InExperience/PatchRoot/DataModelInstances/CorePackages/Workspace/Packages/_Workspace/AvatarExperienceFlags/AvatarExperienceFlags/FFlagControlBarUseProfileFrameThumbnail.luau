local parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("ControlBarUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
