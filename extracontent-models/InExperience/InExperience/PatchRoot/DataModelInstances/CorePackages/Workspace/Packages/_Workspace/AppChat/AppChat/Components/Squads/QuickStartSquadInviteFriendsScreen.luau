local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local resetForSquadLobbyForCompactMode = require(AppChat.Utils.resetForSquadLobbyForCompactMode)
local resetForSquadLobbyForWideMode = require(AppChat.Utils.resetForSquadLobbyForWideMode)

local ArgCheck = require(parent.ArgCheck)
local React = require(parent.React)

local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local EnumScreens = require(AppChat.EnumScreens)

local Constants = require(AppChat.Constants)
local NavProps = Constants.NavProps

local QuickStartSquadInviteFriendsContainer = require(parent.Squads.QuickStartSquadInviteFriendsContainer)

local extended = React.PureComponent:extend("QuickStartSquadInviteFriendsScreen")
function extended.navigationOptions(_)
	return { backButtonEnabled = true }
end

function extended:init()
	self.wideMode = self.props.navigation.getScreenProps(NavProps.WIDE_MODE, false)

	GetTopBarStore(false).setScreenTopBar(EnumScreens.QuickStartSquadInviteFriends, {
		headerText = { raw = "Feature.Squads.Action.Party", shouldLocalize = true },
		backButtonEnabled = true,
		systemButtonText = "Feature.Squads.Action.Start"
	})

	function self.navigateIntoSquadLobby(p)
		local screenProps = self.props.navigation.getScreenProps(NavProps.WIDE_MODE, false)
		local param = self.props.navigation.getParam("partyAttemptId", nil)

		if screenProps then
			resetForSquadLobbyForWideMode(self.props.navigation, p, {
				squadCreateOrJoinAttemptId = param
			})
		else
			resetForSquadLobbyForCompactMode(self.props.navigation, p, {
				squadCreateOrJoinAttemptId = param
			})
		end
	end
	function self.onSelectedFriendsChanged(systemButtonEnabled, systemButtonActivated)
		if not self.wideMode then
			return
		end

		GetTopBarStore(false).setScreenTopBar(EnumScreens.QuickStartSquadInviteFriends, {
			systemButtonEnabled = systemButtonEnabled,
			systemButtonActivated = systemButtonActivated
		})
	end
end

function extended.render(props)
	local notNil = ArgCheck.isNotNil(props.props.navigation, "navigation in CreateNewChatScreen")
	local screenProps = notNil.getScreenProps("topBarHeight", 0)
	local screenProps2 = notNil.getScreenProps("wideMode", false)
	local param = props.props.navigation.getParam("partyAttemptId", nil)

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, not screenProps2 and 0 or -screenProps),
		BackgroundTransparency = 1
	}, { React.createElement(QuickStartSquadInviteFriendsContainer, {
			navigateIntoSquadLobby = props.navigateIntoSquadLobby,
			partyAttemptId = param,
			onSelectedFriendsChanged = props.onSelectedFriendsChanged,
			shouldHideFooterButton = props.wideMode
		}) })
end

function extended.didMount(p)
	if p.wideMode then
		p.onSelectedFriendsChanged(false, nil)
	end
end

return extended
