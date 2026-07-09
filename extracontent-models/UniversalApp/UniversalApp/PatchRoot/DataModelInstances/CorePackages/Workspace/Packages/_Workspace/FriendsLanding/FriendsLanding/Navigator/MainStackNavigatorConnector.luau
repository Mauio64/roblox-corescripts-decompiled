local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local Roact = require(FriendsLanding.dependencies).Roact
local MainStackNavigator = require(FriendsLanding.Navigator.MainStackNavigator)
local FriendsLandingHeaderBar = require(FriendsLanding.Components.FriendsLandingHeaderBar)
local isFromConnectionsHub = require(FriendsLanding.Navigator.isFromConnectionsHub)
local FFlagCreateConnectionsHub = require(FriendsLandingParent.SharedFlags).FFlagCreateConnectionsHub
local v8 = Roact.PureComponent:extend("MainStackNavigatorConnector")

function v8.render(p1) -- line: 13
	-- upvalues: FFlagCreateConnectionsHub (copy), isFromConnectionsHub (copy), Roact (copy), FriendsLandingHeaderBar (copy), MainStackNavigator (copy)
	local navigation = p1.props.navigation
	local v11 = FFlagCreateConnectionsHub and isFromConnectionsHub(navigation)

	return Roact.createFragment({
		layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		topBar = if not FFlagCreateConnectionsHub or not v11 then Roact.createElement(FriendsLandingHeaderBar, {
			navigation = p1.props.navigation
		}) else nil,
		navigator = Roact.createElement(MainStackNavigator, {
			navigation = p1.props.navigation
		})
	})
end

v8.router = MainStackNavigator.router

return v8
