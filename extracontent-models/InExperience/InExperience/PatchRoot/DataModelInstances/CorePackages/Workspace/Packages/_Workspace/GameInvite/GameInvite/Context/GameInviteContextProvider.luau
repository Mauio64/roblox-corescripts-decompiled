local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local FriendsMenu = require(scriptParentParentParent.FriendsMenu)
local React = require(scriptParentParentParent.React)
local GetFFlagEnableCommonFriendsMenu = require(scriptParentParentParent.SharedFlags).GetFFlagEnableCommonFriendsMenu
local FriendsListContextProvider = FriendsMenu.FriendsListContextProvider
local InviteFriendProvider = require(scriptParent.InviteFriendProvider)
local GameDetailsContextProvider = require(scriptParent.GameDetailsContextProvider)

require(scriptParentParent.gameInviteModalType)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), GameDetailsContextProvider (copy), GetFFlagEnableCommonFriendsMenu (copy), InviteFriendProvider (copy), FriendsListContextProvider (copy)
	local trigger = nil
	local inviteMessageId = nil
	local launchData = nil
	local promptMessage = nil
	local v15 = nil
	local rootPlaceId = nil
	local universeId = nil

	if t1.options then
		trigger = t1.options.trigger
		inviteMessageId = t1.options.inviteMessageId
		launchData = t1.options.launchData
		promptMessage = t1.options.promptMessage
		v15 = t1.isCoreScript or false
		rootPlaceId = t1.options.rootPlaceId
		universeId = t1.options.universeId
	end

	return React.createElement(GameDetailsContextProvider, {
		gameDetails = t1.gameDetails,
		serverType = t1.serverType,
		promptMessage = promptMessage,
		trigger = trigger,
		isCoreScript = v15
	}, { if not GetFFlagEnableCommonFriendsMenu() then React.createElement(FriendsListContextProvider, {
		isLoadingCustomParams = t1.isLoadingCustomParams
	}, React.createElement(InviteFriendProvider, {
		trigger = trigger,
		inviteMessageId = inviteMessageId,
		launchData = launchData,
		promptMessage = promptMessage,
		isCoreScript = v15,
		rootPlaceId = rootPlaceId,
		universeId = universeId
	}, t1.children)) else React.createElement(InviteFriendProvider, {
		trigger = trigger,
		inviteMessageId = inviteMessageId,
		launchData = launchData,
		promptMessage = promptMessage,
		isCoreScript = v15,
		rootPlaceId = rootPlaceId,
		universeId = universeId
	}, t1.children) })
end
