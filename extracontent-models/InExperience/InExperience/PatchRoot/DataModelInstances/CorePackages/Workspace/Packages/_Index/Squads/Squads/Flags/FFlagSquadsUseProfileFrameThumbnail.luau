local parent = script:FindFirstAncestor("Squads").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("SquadsUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
