local parent = script:FindFirstAncestor("UserSearch").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("UserSearchUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
