local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local ExpChatShared = require(parent.ExpChatShared)
local SharedFlags = require(parent.SharedFlags)

local FFlagExpChatNewInputBar = require(ExpChat.Flags.FFlagExpChatNewInputBar)
local FFlagExpChatFixInputBarOrphanBorder = require(ExpChat.Flags.FFlagExpChatFixInputBarOrphanBorder)
local selectSelectedTabName = require(ExpChat.selectSelectedTabName)
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)

local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local function getIsChatInputBarVisible(data, flag: boolean) -- 2 equivalent calls inferred from this helper
	local isChatInputBarEnabled = data.ChatVisibility.isChatInputBarEnabled

	if GetFFlagTextChatEnableUniverseChatTabs() and flag and isChatInputBarEnabled._propertyEnabled ~= nil then
		return isChatInputBarEnabled._topBarVisibility
			and isChatInputBarEnabled._coreGuiEnabled
			and not isChatInputBarEnabled._devTextBoxEnabled
	end

	return isChatInputBarEnabled.value
end

local function getSelectedTabType(data) -- 1 equivalent call inferred from this helper
	local channelTabs = data.ChannelTabs

	if channelTabs == nil or channelTabs.allChannelTabs == nil or channelTabs.selectedTabName == nil then
		return nil
	end

	local allChannelTab = channelTabs.allChannelTabs[channelTabs.selectedTabName]
	return allChannelTab and allChannelTab.Type or nil
end

return function(data, data2)
	local channelTabs

	if not FFlagExpChatUseChannelTabsStore then
		channelTabs = data.ChannelTabs
	end

	local v

	if not (FFlagExpChatUseChannelTabsStore or not GetFFlagTextChatEnableUniverseChatTabs()) then
		v = selectSelectedTabName(data)
	end

	local v2

	if FFlagExpChatUseChannelTabsStore then
		v2 = data2.isGlobalTabSelected == true
	else
		v2 = v == "RBXGlobal"
	end

	local v3

	if FFlagExpChatUseChannelTabsStore then
		v3 = data2.hasGlobalChannelTab
	else
		v3 = false
	end

	if not FFlagExpChatUseChannelTabsStore and GetFFlagTextChatEnableUniverseChatTabs() then
		if channelTabs == nil or channelTabs.allChannelTabs == nil then
			v3 = false
		else
			v3 = channelTabs.allChannelTabs.RBXGlobal ~= nil
		end
	end

	local v4

	if FFlagExpChatUseChannelTabsStore then
		v4 = data2.hasFriendsChannelTab
	else
		v4 = false
	end

	if not FFlagExpChatUseChannelTabsStore then
		if channelTabs == nil or channelTabs.allChannelTabs == nil then
			v4 = false
		else
			v4 = channelTabs.allChannelTabs[FriendsChatTabName] ~= nil
		end
	end

	local selectedTabType

	if FFlagExpChatUseChannelTabsStore then
		selectedTabType = data2.selectedTabType
	else
		selectedTabType = getSelectedTabType(data) -- inferred equivalent call
	end

	local renderingFriends = selectedTabType == "FriendsChat"
	local isExperienceChatRendered = not renderingFriends
	local isChatInputBarVisible

	if FFlagExpChatFixInputBarOrphanBorder then
		isChatInputBarVisible = getIsChatInputBarVisible(data, v2) and isExperienceChatRendered -- inferred equivalent call
	else
		isChatInputBarVisible = getIsChatInputBarVisible(data, v2) -- inferred equivalent call
	end

	local v5 = {
		isChatInputBarVisible = isChatInputBarVisible,
		isChatWindowVisible = data.ChatVisibility.isChatWindowEnabled.value,
		isChannelBarVisible = data.ChatVisibility.isChannelBarEnabled.value or GetFFlagTextChatEnableUniverseChatTabs() and v3 and data.ChatVisibility.isChatWindowEnabled.value or v4 and data.ChatVisibility.isChatWindowEnabled.value,
		chatTopBarVisibility = data.ChatVisibility.isChatInputBarEnabled._topBarVisibility and data.ChatVisibility.isChatWindowEnabled._topBarVisibility,
		chatLayoutAlignment = data.ChatLayout.Alignment,
		chatWindowSettings = 0,
		clientSettings = 0,
		selectedTabType = 0,
		renderingFriends = 0,
		isExperienceChatRendered = 0,
		targetTextChannel = 0
	}
	local chatWindowSettings

	if not FFlagExpChatUseChatConfigStore then
		chatWindowSettings = data.ChatLayout.ChatWindowSettings
	end

	v5.chatWindowSettings = chatWindowSettings
	v5.clientSettings = data.ClientSettings

	if FFlagExpChatUseChannelTabsStore then
		selectedTabType = nil
	end

	v5.selectedTabType = selectedTabType
	v5.renderingFriends = renderingFriends
	v5.isExperienceChatRendered = isExperienceChatRendered
	local targetTextChannel

	if FFlagExpChatPresetChatEnabled or FFlagExpChatNewInputBar then
		targetTextChannel = data.TextChannels and data.TextChannels.targetTextChannel
	end

	v5.targetTextChannel = targetTextChannel
	return v5
end
