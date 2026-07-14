local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local DateTime = require(AppChatParent.Time).DateTime
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local EnumScreens = require(AppChat.EnumScreens)
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)
local t1 = {}

local function hasIteratorMember(p1) -- line: 16
	return type(p1) == "table" and p1.CreateIterator ~= nil
end
local function isFriendsPlaceholderConversationId(p2) -- line: 20
	return type(p2) == "string" and string.sub(p2, 1, 8) == "friends:"
end
local function normalizeStoreConversationForRodux(p3) -- line: 24
	-- upvalues: DateTime (copy), ConversationChannels (copy), Cryo (copy)
	local lastUpdated = p3.lastUpdated
	local v19 = nil

	if typeof(lastUpdated) == "DateTime" then
		v19 = DateTime.fromUnixTimestamp(lastUpdated.UnixTimestamp)
	elseif type(lastUpdated) == "table" and typeof(lastUpdated.dateTime) == "DateTime" then
		v19 = DateTime.fromUnixTimestamp(lastUpdated.dateTime.UnixTimestamp)
	end

	local messages = p3.messages
	local v21 = if not (type(messages) == "table" and messages.CreateIterator ~= nil) then ConversationChannels.getEmptyMessages() else p3.messages
	local sendingMessages = p3.sendingMessages
	local v23 = if not (type(sendingMessages) == "table" and sendingMessages.CreateIterator ~= nil) then ConversationChannels.getEmptySendingMessages() else p3.sendingMessages

	if v19 == nil and v21 == p3.messages and v23 == p3.sendingMessages then
		return p3
	end

	return Cryo.Dictionary.join(p3, {
		lastUpdated = v19 or lastUpdated,
		messages = v21,
		sendingMessages = v23
	})
end

function t1.navigateToRootedChatDetails(s1: string) -- line: 55
	-- upvalues: RoactNavigation (copy), EnumScreens (copy)
	return RoactNavigation.Actions.navigate({
		routeName = EnumScreens.ChatLandingStack,
		params = {
			conversationId = s1
		},
		action = RoactNavigation.StackActions.reset({
			index = 1,
			actions = { RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatDetails,
				params = {
					isRooted = true,
					conversationId = s1
				}
			}) }
		})
	})
end
function t1.tryNavigateToRootedChatDetails(t2: {[any]: any}, p4) -- line: 76
	-- upvalues: getFFlagAppChatEnableRootedNavigation (copy), GetConversationStore (copy), ReceivedConversation (copy), normalizeStoreConversationForRodux (copy), ConversationChannels (copy), t1 (copy)
	local v27 = p4 and p4.conversationId

	if not v27 or (p4.rooted ~= true or not getFFlagAppChatEnableRootedNavigation()) then
		return false
	end

	local v28 = GetConversationStore(false).getConversation(v27, false)

	if v28 then
		t2.dispatch(ReceivedConversation(normalizeStoreConversationForRodux(v28)))
	end

	if v28 == nil and (type(v27) ~= "string" or string.sub(v27, 1, 8) ~= "friends:") or v28 ~= nil and v28.source ~= ConversationChannels.Source.Friends then
		t2.fetchLatestConversationDetails(v27)
	end

	t2.callback(t1.navigateToRootedChatDetails(v27))

	return true
end

return t1
