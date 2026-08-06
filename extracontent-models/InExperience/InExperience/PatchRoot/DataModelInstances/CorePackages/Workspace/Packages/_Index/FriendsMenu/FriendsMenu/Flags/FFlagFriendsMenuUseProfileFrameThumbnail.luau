local Parent = script:FindFirstAncestor("FriendsMenu").Parent
local GetFFlagProfileFrameThumbnailEnabled = require(Parent.SharedFlags).GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("FriendsMenuUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
