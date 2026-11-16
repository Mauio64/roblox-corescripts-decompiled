local parent = script:FindFirstAncestor("FriendsMenu").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("FriendsMenuUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
