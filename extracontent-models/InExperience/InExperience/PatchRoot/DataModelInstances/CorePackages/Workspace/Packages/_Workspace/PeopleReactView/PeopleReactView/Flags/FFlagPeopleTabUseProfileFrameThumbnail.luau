local parent = script:FindFirstAncestor("PeopleReactView").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("PeopleTabUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
