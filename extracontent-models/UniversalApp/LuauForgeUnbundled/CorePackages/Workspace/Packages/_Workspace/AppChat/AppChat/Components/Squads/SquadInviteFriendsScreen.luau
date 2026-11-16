local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactRodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")

local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local fFlagEnablePartyQuickStartButton = SharedFlags.FFlagEnablePartyQuickStartButton

local navProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants").NavProps

local SquadInviteFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadInviteFriends")
local SquadInviteFriendsContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadInviteFriendsContainer")

local extended = React.PureComponent:extend("SquadInviteFriendsScreen")

local function navigationOptions(p2)
	return {}
end

extended.navigationOptions = navigationOptions
function extended:init()
	self.wideMode = self.props.navigation.getScreenProps(navProps.WIDE_MODE, false)

	GetTopBarStore(false).setScreenTopBar(EnumScreens.SquadInviteFriends, {
		headerText = fFlagEnablePartyQuickStartButton and {
			raw = "Feature.Squads.Action.Add",
			shouldLocalize = true
		} or nil,
		backButtonEnabled = true,
		systemButtonText = "Feature.Squads.Action.Add"
	})

	function self.onSelectedFriendsChanged(p2, p3)
		if not self.wideMode then
			return
		end

		GetTopBarStore(false).setScreenTopBar(EnumScreens.SquadInviteFriends, {
			systemButtonEnabled = p2,
			systemButtonActivated = p3
		})
	end
end

function extended.render(props)
	local createElement = React.createElement
	local v5 = if fFlagEnablePartyQuickStartButton then SquadInviteFriendsContainer else SquadInviteFriends
	local v6 = {
		participants = props.props.participants,
		onSelectedFriendsChanged = 0,
		shouldHideFooterButton = 0
	}
	local v7 = if props.wideMode then props.onSelectedFriendsChanged else nil
	v6.onSelectedFriendsChanged = v7
	v6.shouldHideFooterButton = props.wideMode
	return createElement(v5, v6)
end

function extended.didMount(p2)
	if p2.wideMode then
		p2.onSelectedFriendsChanged(false, nil)
	end
end

local v5 = RoactRodux.connect(function(p2, p3)
	local param = p3.navigation.getParam("conversationId")
	local conversation = p2.ChatAppReducer.Conversations[param]

	return {
		participants = conversation and conversation.participants or nil
	}
end)(extended)
v5.navigationOptions = navigationOptions

return v5
