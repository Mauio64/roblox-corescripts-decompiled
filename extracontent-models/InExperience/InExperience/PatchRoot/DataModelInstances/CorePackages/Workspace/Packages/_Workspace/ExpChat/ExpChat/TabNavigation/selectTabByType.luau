local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)

local TargetTextChannelPropertyChanged = ExpChatShared.Actions.TargetTextChannelPropertyChanged
local UniverseChatChannelSelected = ExpChatShared.Actions.UniverseChatChannelSelected
local FriendsChatChannelSelected = ExpChatShared.Actions.FriendsChatChannelSelected
local TextChatChannelSelected = ExpChatShared.Actions.TextChatChannelSelected

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatSelectTextChatTabByName = SharedFlags.FFlagExpChatSelectTextChatTabByName

local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)

local function selectTabByType(callback, data)
	local channelName = data.channelName
	local tabType = data.tabType
	local shouldReorderTabs = data.shouldReorderTabs

	if tabType == "UniverseChat" then
		if FFlagExpChatGlobalTabDefault then
			callback(UniverseChatChannelSelected(channelName, true))
		else
			callback(UniverseChatChannelSelected(channelName))
		end
	elseif FFlagExpChatUseChannelTabsStore or not FFlagExpChatEnableFriendsTab or tabType ~= "FriendsChat" then
		if FFlagExpChatSelectTextChatTabByName and tabType == "TextChat" then
			callback(TextChatChannelSelected(channelName, shouldReorderTabs))
		elseif data.textChannel then
			callback(TargetTextChannelPropertyChanged(data.textChannel, shouldReorderTabs))
		end
	else
		callback(FriendsChatChannelSelected(channelName))
	end

	if FFlagExpChatUseChannelTabsStore then
		local channelTabsStore = GetChannelTabsStore(false)

		if FFlagExpChatGlobalTabDefault then
			channelTabsStore.setTargetChannel(channelName, shouldReorderTabs, true)
		else
			channelTabsStore.setTargetChannel(channelName, shouldReorderTabs)
		end
	end
end

return selectTabByType
