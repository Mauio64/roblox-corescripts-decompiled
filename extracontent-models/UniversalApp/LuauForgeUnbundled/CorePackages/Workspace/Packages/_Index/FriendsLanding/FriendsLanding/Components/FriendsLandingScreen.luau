local roact = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies").Roact
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")
local FriendsLandingContainer = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingContainer")

local extended = roact.PureComponent:extend("FriendsLandingScreen")

extended.defaultProps = { friends = {} }

function extended.render(p2)
	return FriendsLandingContext.with(function(p3)
		return roact.createElement(FriendsLandingContainer, {})
	end)
end

return extended
