local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.dependencies).React
local DiscoverabilityContext = require(ParentParent.Components.DiscoverabilityContext.DiscoverabilityContext)
local DiscoverabilityOverlayContainer = require(ParentParent.Components.DiscoverabilityOverlay.DiscoverabilityOverlayContainer)

local function DiscoverabilityOverlayEntryPoint(p1) -- line: 10
	-- upvalues: React (copy), DiscoverabilityContext (copy), DiscoverabilityOverlayContainer (copy)
	return React.createElement(DiscoverabilityContext(DiscoverabilityOverlayContainer), p1)
end

return DiscoverabilityOverlayEntryPoint
