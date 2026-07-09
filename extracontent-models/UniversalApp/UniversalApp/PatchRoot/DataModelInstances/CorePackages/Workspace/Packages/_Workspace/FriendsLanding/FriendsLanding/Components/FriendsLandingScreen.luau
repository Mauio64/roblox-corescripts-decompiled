local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local Roact = require(FriendsLanding.dependencies).Roact
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local FriendsLandingContainer = require(FriendsLanding.Components.FriendsLandingContainer)
local v5 = Roact.PureComponent:extend("FriendsLandingScreen")

v5.defaultProps = {
	friends = {}
}

function v5.render(_) -- line: 13
	-- upvalues: FriendsLandingContext (copy), Roact (copy), FriendsLandingContainer (copy)
	return FriendsLandingContext.with(function(_) -- line: 14
		-- upvalues: Roact (copy), FriendsLandingContainer (copy)
		return Roact.createElement(FriendsLandingContainer, {})
	end)
end

return v5
