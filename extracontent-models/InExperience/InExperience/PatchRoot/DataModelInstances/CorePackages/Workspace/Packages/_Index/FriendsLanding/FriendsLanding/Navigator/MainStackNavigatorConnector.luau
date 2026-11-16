local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local roact = dependencies.Roact
local MainStackNavigator = require(FriendsLanding.Navigator.MainStackNavigator)
local FriendsLandingHeaderBar = require(FriendsLanding.Components.FriendsLandingHeaderBar)
local isFromConnectionsHub = require(FriendsLanding.Navigator.isFromConnectionsHub)
local Constants = require(FriendsLanding.Common.Constants)

local SharedFlags = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local FFlagFixFriendsListGapInConnectionsHub = require(FriendsLanding.Flags.FFlagFixFriendsListGapInConnectionsHub)

local extended = roact.PureComponent:extend("MainStackNavigatorConnector")

function extended.render(p)
	local navigation = p.props.navigation
	local v = FFlagCreateConnectionsHub and isFromConnectionsHub(navigation)
	local v2 = not (FFlagCreateConnectionsHub and v)

	local v3 = roact.createElement(MainStackNavigator, { navigation = p.props.navigation })

	local createFragment = roact.createFragment
	local v4 = {
		layout = roact.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
		topBar = 0,
		navigator = 0
	}
	local topBar

	if v2 then
		topBar = roact.createElement(FriendsLandingHeaderBar, { navigation = p.props.navigation })
	end

	v4.topBar = topBar

	if FFlagFixFriendsListGapInConnectionsHub then
		v3 = roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, not v2 and 0 or -Constants.TOP_BAR_HEIGHT),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}, { MainStackNavigator = v3 })
	end

	v4.navigator = v3
	return createFragment(v4)
end

extended.router = MainStackNavigator.router

return extended
