local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local roact = dependencies.Roact
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local FriendsLandingContainer = require(FriendsLanding.Components.FriendsLandingContainer)

local extended = roact.PureComponent:extend("FriendsLandingScreen")

extended.defaultProps = { friends = {} }

function extended.render(_)
	return FriendsLandingContext.with(function(_)
		return roact.createElement(FriendsLandingContainer, {})
	end)
end

return extended
