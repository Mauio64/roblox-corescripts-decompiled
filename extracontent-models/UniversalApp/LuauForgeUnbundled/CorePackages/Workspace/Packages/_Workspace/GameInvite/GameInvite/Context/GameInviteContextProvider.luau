local FriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FriendsMenu")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local getFFlagEnableCommonFriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").GetFFlagEnableCommonFriendsMenu

local friendsListContextProvider = FriendsMenu.FriendsListContextProvider
local InviteFriendProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/InviteFriendProvider")
local GameDetailsContextProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameDetailsContextProvider")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

return function(props)
	local trigger, inviteMessageId, launchData, promptMessage, isCoreScript, rootPlaceId, universeId

	if props.options then
		trigger = props.options.trigger
		inviteMessageId = props.options.inviteMessageId
		launchData = props.options.launchData
		promptMessage = props.options.promptMessage
		isCoreScript = props.isCoreScript or false
		rootPlaceId = props.options.rootPlaceId
		universeId = props.options.universeId
	end

	return React.createElement(GameDetailsContextProvider, {
		gameDetails = props.gameDetails,
		serverType = props.serverType,
		promptMessage = promptMessage,
		trigger = trigger,
		isCoreScript = isCoreScript
	}, { if getFFlagEnableCommonFriendsMenu() then React.createElement(InviteFriendProvider, {
			trigger = trigger,
			inviteMessageId = inviteMessageId,
			launchData = launchData,
			promptMessage = promptMessage,
			isCoreScript = isCoreScript,
			rootPlaceId = rootPlaceId,
			universeId = universeId
		}, props.children) else React.createElement(
			friendsListContextProvider,
			{ isLoadingCustomParams = props.isLoadingCustomParams },
			React.createElement(InviteFriendProvider, {
				trigger = trigger,
				inviteMessageId = inviteMessageId,
				launchData = launchData,
				promptMessage = promptMessage,
				isCoreScript = isCoreScript,
				rootPlaceId = rootPlaceId,
				universeId = universeId
			}, props.children)
		) })
end
