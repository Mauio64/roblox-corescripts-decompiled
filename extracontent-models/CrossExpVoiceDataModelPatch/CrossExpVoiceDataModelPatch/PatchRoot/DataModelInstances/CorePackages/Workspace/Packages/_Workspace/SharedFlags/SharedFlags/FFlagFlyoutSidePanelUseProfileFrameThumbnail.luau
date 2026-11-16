local GetFFlagProfileFrameThumbnailEnabled = require(script.Parent.GetFFlagProfileFrameThumbnailEnabled)

return game:DefineFastFlag("FlyoutSidePanelUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
