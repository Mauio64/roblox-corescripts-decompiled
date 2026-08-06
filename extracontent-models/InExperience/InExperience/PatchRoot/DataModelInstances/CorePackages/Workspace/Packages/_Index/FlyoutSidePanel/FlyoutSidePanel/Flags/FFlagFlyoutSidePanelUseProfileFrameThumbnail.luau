local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local GetFFlagProfileFrameThumbnailEnabled = require(Parent.SharedFlags).GetFFlagProfileFrameThumbnailEnabled

return game:DefineFastFlag("FlyoutSidePanelUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
