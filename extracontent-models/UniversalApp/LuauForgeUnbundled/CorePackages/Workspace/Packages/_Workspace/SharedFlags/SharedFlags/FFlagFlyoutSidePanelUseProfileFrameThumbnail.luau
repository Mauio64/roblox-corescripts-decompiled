local GetFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagProfileFrameThumbnailEnabled")

return game:DefineFastFlag("FlyoutSidePanelUseProfileFrameThumbnail", false) and GetFFlagProfileFrameThumbnailEnabled()
