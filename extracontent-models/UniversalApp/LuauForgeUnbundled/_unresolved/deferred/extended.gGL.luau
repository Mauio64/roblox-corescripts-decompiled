local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local module = require("@luauforge/deferred/gGM")
local module2 = require("@luauforge/deferred/gGN")

local roact = module2.Roact
local eventStream = module2.EventStream
local diag = module2.Diag
local request = module2.request

local module3 = require("@luauforge/deferred/gGO")

local extended = roact.PureComponent:extend("ShareTargetGameEntrypoint")
extended.defaultProps = {
	placeId = nil,
	eventStream = eventStream.new(RbxAnalyticsService),
	diag = diag.new(RbxAnalyticsService),
	isVisible = false
}

function extended.render(p2)
	return roact.createElement(module3, {
		placeId = p2.props.placeId,
		analytics = module(p2.props.eventStream, p2.props.diag),
		networkImpl = request
	})
end

return extended
