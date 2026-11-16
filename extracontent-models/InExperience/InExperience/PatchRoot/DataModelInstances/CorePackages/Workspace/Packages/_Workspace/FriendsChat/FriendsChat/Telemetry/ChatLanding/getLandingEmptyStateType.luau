local parent = script:FindFirstAncestor("FriendsChat").Parent

local EmptyStateType = require(parent.AppChat.EmptyStateType)

local function getLandingEmptyStateType(data, flag: boolean)
	if flag then
		return nil
	end

	if data.shouldShowBlockingError then
		return EmptyStateType.ConversationsLoadErrorView
	end

	if not data.shouldShowEmptyState then
		return nil
	end

	if data.hasNoFriends then
		return EmptyStateType.NoFriendsView
	end

	return EmptyStateType.EmptyConversationList
end

return getLandingEmptyStateType
