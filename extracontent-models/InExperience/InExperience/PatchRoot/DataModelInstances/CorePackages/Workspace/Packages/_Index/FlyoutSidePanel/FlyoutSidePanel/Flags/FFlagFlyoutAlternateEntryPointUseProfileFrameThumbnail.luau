local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("FlyoutAlternateEntryPointUseProfileFrameThumbnail", false)
	and GetFFlagProfileFrameThumbnailEnabled()
