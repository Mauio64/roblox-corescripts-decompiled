local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")

local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local ReceivedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedConversation")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local getFFlagAppChatEnableRootedNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatEnableRootedNavigation")
local ConversationRoduxSeed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/ConversationRoduxSeed")
local isFriendsPlaceholderConversationId = ConversationRoduxSeed.isFriendsPlaceholderConversationId
local normalizeStoreConversationForRodux = ConversationRoduxSeed.normalizeStoreConversationForRodux

local v5 = {}

function v5.navigateToRootedChatDetails(p2, p3)
	return RoactNavigation.Actions.navigate({
		routeName = EnumScreens.ChatLandingStack,
		params = { conversationId = p2 },
		action = RoactNavigation.StackActions.reset({
			index = 1,
			actions = { RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatDetails,
					params = {
						conversationId = p2,
						isRooted = true,
						rootedNavigationRequestId = p3
					}
				}) }
		})
	})
end

function v5.tryNavigateToRootedChatDetails(data, data2): boolean
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

	data.callback(v5.navigateToRootedChatDetails(conversationId, data2.rootedNavigationRequestId))

	return true
end

return v5
