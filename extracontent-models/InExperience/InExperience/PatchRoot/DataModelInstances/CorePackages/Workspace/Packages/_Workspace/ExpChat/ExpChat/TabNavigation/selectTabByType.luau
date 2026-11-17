local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)

local TargetTextChannelPropertyChanged = ExpChatShared.Actions.TargetTextChannelPropertyChanged
local UniverseChatChannelSelected = ExpChatShared.Actions.UniverseChatChannelSelected
local FriendsChatChannelSelected = ExpChatShared.Actions.FriendsChatChannelSelected
local TextChatChannelSelected = ExpChatShared.Actions.TextChatChannelSelected

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatSelectTextChatTabByName = SharedFlags.FFlagExpChatSelectTextChatTabByName
local FFlagExpChatStickyTabs = SharedFlags.FFlagExpChatStickyTabs

local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

local isUserSelectedTabTracked = require(ExpChat.isUserSelectedTabTracked)

local function selectTabByType(callback, data)
	local channelName = data.channelName
	local tabType = data.tabType
	local shouldReorderTabs = data.shouldReorderTabs

	if tabType == "UniverseChat" then
		if isUserSelectedTabTracked() then
			callback(UniverseChatChannelSelected(channelName, true))
		else
			callback(UniverseChatChannelSelected(channelName))
		end
	elseif FFlagExpChatUseChannelTabsStore or tabType ~= "FriendsChat" then
		if FFlagExpChatSelectTextChatTabByName and tabType == "TextChat" then
			callback(TextChatChannelSelected(channelName, shouldReorderTabs))
		elseif data.textChannel then
			if FFlagExpChatStickyTabs then
				callback(TargetTextChannelPropertyChanged(data.textChannel, shouldReorderTabs, true))
			else
				callback(TargetTextChannelPropertyChanged(data.textChannel, shouldReorderTabs))
			end
		end
	else
		callback(FriendsChatChannelSelected(channelName))
	end

	if FFlagExpChatUseChannelTabsStore then
		local channelTabsStore = GetChannelTabsStore(false)

		if isUserSelectedTabTracked() then
			channelTabsStore.setTargetChannel(channelName, shouldReorderTabs, true)
		else
			channelTabsStore.setTargetChannel(channelName, shouldReorderTabs)
		end
	end
end

return selectTabByType
