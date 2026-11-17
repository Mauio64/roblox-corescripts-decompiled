local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local ExpChatShared = require(parent.ExpChatShared)
local SharedFlags = require(parent.SharedFlags)
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)
local requestSelectTab = require(ExpChat.ExternalNavigation.requestSelectTab)

local FriendsChatChannelSelected = ExpChatShared.Actions.FriendsChatChannelSelected
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatStickyTabs = SharedFlags.FFlagExpChatStickyTabs

local function requestSelectFriendsTab(): boolean
	local store = ExpChatShared.context.store

	if not (store ~= nil and requestSelectTab(FriendsChatTabName, FFlagExpChatStickyTabs and true or nil)) then
		return false
	end

	if not FFlagExpChatUseChannelTabsStore then
		store:dispatch(FriendsChatChannelSelected(FriendsChatTabName))
	end

	return true
end

return requestSelectFriendsTab
