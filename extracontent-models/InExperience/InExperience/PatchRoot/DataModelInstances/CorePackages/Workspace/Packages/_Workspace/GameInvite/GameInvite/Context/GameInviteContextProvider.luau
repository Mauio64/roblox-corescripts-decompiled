local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local FriendsMenu = require(parent3.FriendsMenu)
local React = require(parent3.React)
local SharedFlags = require(parent3.SharedFlags)
local GetFFlagEnableCommonFriendsMenu = SharedFlags.GetFFlagEnableCommonFriendsMenu

local FriendsListContextProvider = FriendsMenu.FriendsListContextProvider
local InviteFriendProvider = require(parent.InviteFriendProvider)
local GameDetailsContextProvider = require(parent.GameDetailsContextProvider)
require(parent2.gameInviteModalType)

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

	local createElement = React.createElement
	local v = {
		gameDetails = props.gameDetails,
		serverType = props.serverType,
		promptMessage = promptMessage,
		trigger = trigger,
		isCoreScript = isCoreScript
	}
	local v2

	if GetFFlagEnableCommonFriendsMenu() then
		v2 = React.createElement(InviteFriendProvider, {
			trigger = trigger,
			inviteMessageId = inviteMessageId,
			launchData = launchData,
			promptMessage = promptMessage,
			isCoreScript = isCoreScript,
			rootPlaceId = rootPlaceId,
			universeId = universeId
		}, props.children)
	else
		v2 = React.createElement(
			FriendsListContextProvider,
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
		)
	end

	return createElement(GameDetailsContextProvider, v, { v2 })
end
