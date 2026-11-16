local parent = script:FindFirstAncestor("AppChat").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("AppChatUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
