local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ShareTargetGame = script:FindFirstAncestor("ShareTargetGame")
local analytics = require(ShareTargetGame.analytics)
local dependencies = require(ShareTargetGame.dependencies)
local Roact = dependencies.Roact
local EventStream = dependencies.EventStream
local Diag = dependencies.Diag
local request = dependencies.request
local ShareTargetGameContainer = require(script.Parent.ShareTargetGameContainer)
local v10 = Roact.PureComponent:extend("ShareTargetGameEntrypoint")

v10.defaultProps = {
	placeId = nil,
	isVisible = false,
	eventStream = EventStream.new(RbxAnalyticsService),
	diag = Diag.new(RbxAnalyticsService)
}

function v10.render(p1) -- line: 22
	-- upvalues: Roact (copy), ShareTargetGameContainer (copy), analytics (copy), request (copy)
	return Roact.createElement(ShareTargetGameContainer, {
		placeId = p1.props.placeId,
		analytics = analytics(p1.props.eventStream, p1.props.diag),
		networkImpl = request
	})
end

return v10
