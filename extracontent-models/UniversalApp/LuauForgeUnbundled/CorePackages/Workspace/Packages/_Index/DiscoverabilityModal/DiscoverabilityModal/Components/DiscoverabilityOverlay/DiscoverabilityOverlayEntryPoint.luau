local react = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies").React

local DiscoverabilityContext = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Components/DiscoverabilityContext/DiscoverabilityContext")

local DiscoverabilityOverlayContainer = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Components/DiscoverabilityOverlay/DiscoverabilityOverlayContainer")

local function DiscoverabilityOverlayEntryPoint(p2)
	return react.createElement(DiscoverabilityContext(DiscoverabilityOverlayContainer), p2)
end

return DiscoverabilityOverlayEntryPoint
