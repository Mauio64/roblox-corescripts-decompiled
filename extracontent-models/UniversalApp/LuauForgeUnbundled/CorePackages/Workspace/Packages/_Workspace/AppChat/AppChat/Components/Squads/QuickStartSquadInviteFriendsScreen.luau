local resetForSquadLobbyForCompactMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/resetForSquadLobbyForCompactMode")
local resetForSquadLobbyForWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/resetForSquadLobbyForWideMode")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local navProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants").NavProps

local QuickStartSquadInviteFriendsContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/QuickStartSquadInviteFriendsContainer")

local extended = React.PureComponent:extend("QuickStartSquadInviteFriendsScreen")
function extended.navigationOptions(p2)
	return { backButtonEnabled = true }
end

function extended:init()
	self.wideMode = self.props.navigation.getScreenProps(navProps.WIDE_MODE, false)

	GetTopBarStore(false).setScreenTopBar(EnumScreens.QuickStartSquadInviteFriends, {
		headerText = { raw = "Feature.Squads.Action.Party", shouldLocalize = true },
		backButtonEnabled = true,
		systemButtonText = "Feature.Squads.Action.Start"
	})

	function self.navigateIntoSquadLobby(p2)
		local screenProps = self.props.navigation.getScreenProps(navProps.WIDE_MODE, false)
		local param = self.props.navigation.getParam("partyAttemptId", nil)

		if screenProps then
			resetForSquadLobbyForWideMode(self.props.navigation, p2, { squadCreateOrJoinAttemptId = param })
		else
			resetForSquadLobbyForCompactMode(self.props.navigation, p2, { squadCreateOrJoinAttemptId = param })
		end
	end
	function self.onSelectedFriendsChanged(p2, p3)
		if not self.wideMode then
			return
		end

		GetTopBarStore(false).setScreenTopBar(EnumScreens.QuickStartSquadInviteFriends, {
			systemButtonEnabled = p2,
			systemButtonActivated = p3
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

function extended.didMount(p2)
	if p2.wideMode then
		p2.onSelectedFriendsChanged(false, nil)
	end
end

return extended
