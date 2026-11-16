local parent = script:FindFirstAncestor("SplitPane").Parent

local SharedFlags = require(parent.SharedFlags)

local SplitPaneVariant = require(script.Parent.SplitPaneVariant)

local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local FFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay
local FFlagSplitPaneEducationalTour = SharedFlags.FFlagSplitPaneEducationalTour

local function isSplitPaneTourSupported()
	return FFlagEnableSplitPane
		and FFlagEnableSplitPaneAvatarOverlay
		and FFlagSplitPaneEducationalTour
		and SplitPaneVariant.isEducationModalEnabled()
end

return isSplitPaneTourSupported
