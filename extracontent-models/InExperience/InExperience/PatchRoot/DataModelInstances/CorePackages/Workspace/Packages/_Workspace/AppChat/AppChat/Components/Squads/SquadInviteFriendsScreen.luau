local AppChat = script:FindFirstAncestor("AppChat")

local parent = AppChat.Parent

local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local SharedFlags = require(parent.SharedFlags)

local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local EnumScreens = require(AppChat.EnumScreens)

local FFlagEnablePartyQuickStartButton = SharedFlags.FFlagEnablePartyQuickStartButton

local Constants = require(AppChat.Constants)
local NavProps = Constants.NavProps

local SquadInviteFriends = require(parent.Squads.SquadInviteFriends)
local SquadInviteFriendsContainer = require(parent.Squads.SquadInviteFriendsContainer)

local extended = React.PureComponent:extend("SquadInviteFriendsScreen")

local function navigationOptions(_)
	return {}
end

extended.navigationOptions = navigationOptions
function extended:init()
	self.wideMode = self.props.navigation.getScreenProps(NavProps.WIDE_MODE, false)

	GetTopBarStore(false).setScreenTopBar(EnumScreens.SquadInviteFriends, {
		headerText = FFlagEnablePartyQuickStartButton and {
			raw = "Feature.Squads.Action.Add",
			shouldLocalize = true
		} or nil,
		backButtonEnabled = true,
		systemButtonText = "Feature.Squads.Action.Add"
	})

	function self.onSelectedFriendsChanged(systemButtonEnabled, systemButtonActivated)
		if not self.wideMode then
			return
		end

		GetTopBarStore(false).setScreenTopBar(EnumScreens.SquadInviteFriends, {
			systemButtonEnabled = systemButtonEnabled,
			systemButtonActivated = systemButtonActivated
		})
	end
end

function extended.render(props)
	local createElement = React.createElement
	local v

	if FFlagEnablePartyQuickStartButton then
		v = SquadInviteFriendsContainer
	else
		v = SquadInviteFriends
	end

	local v2 = {
		participants = props.props.participants,
		onSelectedFriendsChanged = 0,
		shouldHideFooterButton = 0
	}
	local onSelectedFriendsChanged

	if props.wideMode then
		onSelectedFriendsChanged = props.onSelectedFriendsChanged
	end

	v2.onSelectedFriendsChanged = onSelectedFriendsChanged
	v2.shouldHideFooterButton = props.wideMode
	return createElement(v, v2)
end

function extended.didMount(p)
	if p.wideMode then
		p.onSelectedFriendsChanged(false, nil)
	end
end

local v = RoactRodux.connect(function(p, p2)
	local param = p2.navigation.getParam("conversationId")
	local conversation = p.ChatAppReducer.Conversations[param]

	return {
		participants = conversation and conversation.participants or nil
	}
end)(extended)
v.navigationOptions = navigationOptions

return v
