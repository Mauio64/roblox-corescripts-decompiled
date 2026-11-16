local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)

local react = dependencies.React

local DiscoverabilityContext = require(parent.Components.DiscoverabilityContext.DiscoverabilityContext)

local DiscoverabilityOverlayContainer = require(parent.Components.DiscoverabilityOverlay.DiscoverabilityOverlayContainer)

local function DiscoverabilityOverlayEntryPoint(p)
	return react.createElement(DiscoverabilityContext(DiscoverabilityOverlayContainer), p)
end

return DiscoverabilityOverlayEntryPoint
