local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactNavigation = require(parent.RoactNavigation)

local ConversationChannels = require(AppChat.Models.ConversationChannels)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local EnumScreens = require(AppChat.EnumScreens)
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)
local ConversationRoduxSeed = require(AppChat.Utils.ConversationRoduxSeed)
local isFriendsPlaceholderConversationId = ConversationRoduxSeed.isFriendsPlaceholderConversationId
local normalizeStoreConversationForRodux = ConversationRoduxSeed.normalizeStoreConversationForRodux

local RootedChatDetailsNavigation = {}

function RootedChatDetailsNavigation.navigateToRootedChatDetails(conversationId: string, rootedNavigationRequestId: number?)
	return RoactNavigation.Actions.navigate({
		routeName = EnumScreens.ChatLandingStack,
		params = { conversationId = conversationId },
		action = RoactNavigation.StackActions.reset({
			index = 1,
			actions = { RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatDetails,
					params = {
						conversationId = conversationId,
						isRooted = true,
						rootedNavigationRequestId = rootedNavigationRequestId
					}
				}) }
		})
	})
end

function RootedChatDetailsNavigation.tryNavigateToRootedChatDetails(data, data2): boolean
	local conversationId = data2 and data2.conversationId

	if not conversationId or data2.rooted ~= true or not getFFlagAppChatEnableRootedNavigation() then
		return false
	end

	local conversation = GetConversationStore(false).getConversation(conversationId, false)

	if conversation then
		data.dispatch(ReceivedConversation(normalizeStoreConversationForRodux(conversation)))
	end

	if
		conversation == nil and not isFriendsPlaceholderConversationId(conversationId)
		or conversation ~= nil and conversation.source ~= ConversationChannels.Source.Friends
	then
		data.fetchLatestConversationDetails(conversationId)
	end

	data.callback(RootedChatDetailsNavigation.navigateToRootedChatDetails(
		conversationId,
		data2.rootedNavigationRequestId
	))

	return true
end

return RootedChatDetailsNavigation
