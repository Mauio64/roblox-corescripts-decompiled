local roact = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies").Roact
local module = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Navigator/MainStackNavigator")
local FriendsLandingHeaderBar = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingHeaderBar")
local isFromConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Navigator/isFromConnectionsHub")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Common/Constants")

local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagCreateConnectionsHub
local FFlagFixFriendsListGapInConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Flags/FFlagFixFriendsListGapInConnectionsHub")

local extended = roact.PureComponent:extend("MainStackNavigatorConnector")

function extended.render(p2)
	local navigation = p2.props.navigation
	local v5 = fFlagCreateConnectionsHub and isFromConnectionsHub(navigation)
	local v6 = not (fFlagCreateConnectionsHub and v5)

	local v7 = roact.createElement(module, { navigation = p2.props.navigation })

	local createFragment = roact.createFragment
	local v8 = {
		layout = roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		topBar = 0,
		navigator = 0
	}

	local v9 = if v6 then roact.createElement(FriendsLandingHeaderBar, {
		navigation = p2.props.navigation
	}) else nil
	v8.topBar = v9

	if FFlagFixFriendsListGapInConnectionsHub then
		v7 = roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, not v6 and 0 or -Constants.TOP_BAR_HEIGHT),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}, { MainStackNavigator = v7 })
	end

	v8.navigator = v7
	return createFragment(v8)
end

extended.router = module.router

return extended
