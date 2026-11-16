local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local ExpChatShared = require(parent.ExpChatShared)
local SharedFlags = require(parent.SharedFlags)
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)
local requestSelectTab = require(ExpChat.ExternalNavigation.requestSelectTab)

local FriendsChatChannelSelected = ExpChatShared.Actions.FriendsChatChannelSelected
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local function requestSelectFriendsTab(): boolean
	if not FFlagExpChatEnableFriendsTab then
		return false
	end

	local store = ExpChatShared.context.store

	if not (store ~= nil and requestSelectTab(FriendsChatTabName)) then
		return false
	end

	if not FFlagExpChatUseChannelTabsStore then
		store:dispatch(FriendsChatChannelSelected(FriendsChatTabName))
	end

	return true
end

return requestSelectFriendsTab
