local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local getFFlagExpChatEnableChannelTabsUI = require(ExpChat.Flags.getFFlagExpChatEnableChannelTabsUI)
local FFlagExpChatNewInputBar = require(ExpChat.Flags.FFlagExpChatNewInputBar)
local selectSelectedTabName = require(ExpChat.selectSelectedTabName)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagExpChatChannelTabRefactor = SharedFlags.FFlagExpChatChannelTabRefactor
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

local function getIsChatInputBarVisible(p1) -- line: 18
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), selectSelectedTabName (copy)
	local isChatInputBarEnabled = p1.ChatVisibility.isChatInputBarEnabled

	if GetFFlagTextChatEnableUniverseChatTabs() and (selectSelectedTabName(p1) == "RBXGlobal" and isChatInputBarEnabled._propertyEnabled ~= nil) then
		return isChatInputBarEnabled._topBarVisibility and (isChatInputBarEnabled._coreGuiEnabled and not isChatInputBarEnabled._devTextBoxEnabled)
	end

	return isChatInputBarEnabled.value
end
local function getSelectedTabType(p2) -- line: 33
	-- upvalues: FFlagExpChatChannelTabRefactor (copy)
	if not FFlagExpChatChannelTabRefactor then
		return nil
	end

	local ChannelTabs = p2.ChannelTabs

	if ChannelTabs == nil or ChannelTabs.allChannelTabs == nil or ChannelTabs.selectedTabName == nil then
		return nil
	end

	local v20 = ChannelTabs.allChannelTabs[ChannelTabs.selectedTabName]

	return v20 and v20.Type or nil
end

return function(p3, _) -- line: 45
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy), FFlagExpChatUseMessagesStore (copy), selectSelectedTabName (copy), getFFlagExpChatEnableChannelTabsUI (copy), FFlagExpChatUseChatConfigStore (copy), FFlagExpChatChannelTabRefactor (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatNewInputBar (copy)
	local v23 = false

	if GetFFlagTextChatEnableUniverseChatTabs() then
		local ChannelTabs = p3.ChannelTabs

		v23 = ChannelTabs ~= nil and (ChannelTabs.allChannelTabs ~= nil and ChannelTabs.allChannelTabs.RBXGlobal ~= nil)
	end

	local v25 = false

	if FFlagExpChatEnableFriendsTab then
		local ChannelTabs = p3.ChannelTabs

		v25 = ChannelTabs ~= nil and (ChannelTabs.allChannelTabs ~= nil and ChannelTabs.allChannelTabs.FriendsChat ~= nil)
	end

	local t1 = {
		canLocalUserChat = if not FFlagExpChatUseMessagesStore then p3.CanLocalUserChat else nil
	}
	local isChatInputBarEnabled = p3.ChatVisibility.isChatInputBarEnabled

	t1.isChatInputBarVisible = if not GetFFlagTextChatEnableUniverseChatTabs() or (selectSelectedTabName(p3) ~= "RBXGlobal" or isChatInputBarEnabled._propertyEnabled == nil) then isChatInputBarEnabled.value else isChatInputBarEnabled._topBarVisibility and (isChatInputBarEnabled._coreGuiEnabled and not isChatInputBarEnabled._devTextBoxEnabled)
	t1.isChatWindowVisible = p3.ChatVisibility.isChatWindowEnabled.value
	t1.isChannelBarVisible = not not getFFlagExpChatEnableChannelTabsUI() and (p3.ChatVisibility.isChannelBarEnabled.value or (GetFFlagTextChatEnableUniverseChatTabs() and (not not v23 and p3.ChatVisibility.isChatWindowEnabled.value) or v25 and p3.ChatVisibility.isChatWindowEnabled.value))
	t1.chatTopBarVisibility = p3.ChatVisibility.isChatInputBarEnabled._topBarVisibility and p3.ChatVisibility.isChatWindowEnabled._topBarVisibility
	t1.chatLayoutAlignment = p3.ChatLayout.Alignment
	t1.chatWindowSettings = if not FFlagExpChatUseChatConfigStore then p3.ChatLayout.ChatWindowSettings else nil
	t1.clientSettings = p3.ClientSettings

	local v29

	if not FFlagExpChatChannelTabRefactor then
		v29 = nil
	else
		local ChannelTabs = p3.ChannelTabs

		if ChannelTabs == nil or ChannelTabs.allChannelTabs == nil or ChannelTabs.selectedTabName == nil then
			v29 = nil
		else
			local v31 = ChannelTabs.allChannelTabs[ChannelTabs.selectedTabName]

			v29 = v31 and v31.Type or nil
		end
	end

	t1.selectedTabType = v29
	t1.targetTextChannel = if not FFlagExpChatPresetChatEnabled and not FFlagExpChatNewInputBar then nil else p3.TextChannels and p3.TextChannels.targetTextChannel

	return t1
end
