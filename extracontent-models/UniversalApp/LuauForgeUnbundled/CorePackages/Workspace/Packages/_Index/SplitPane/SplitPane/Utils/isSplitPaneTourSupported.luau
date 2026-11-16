local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags")

local SplitPaneVariant = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/SplitPaneVariant")

local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay
local fFlagSplitPaneEducationalTour = SharedFlags.FFlagSplitPaneEducationalTour

local function isSplitPaneTourSupported()
	return fFlagEnableSplitPane
		and fFlagEnableSplitPaneAvatarOverlay
		and fFlagSplitPaneEducationalTour
		and SplitPaneVariant.isEducationModalEnabled()
end

return isSplitPaneTourSupported
