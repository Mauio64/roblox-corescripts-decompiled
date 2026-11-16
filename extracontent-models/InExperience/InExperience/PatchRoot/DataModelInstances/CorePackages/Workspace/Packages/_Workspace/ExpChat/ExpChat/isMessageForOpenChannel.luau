local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local GetChannelTabsStore

if FFlagExpChatUseChannelTabsStore then
	GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
else
	GetChannelTabsStore = nil
end

local function getOpenChannelName(p)
	local textChannels = p.TextChannels

	if textChannels == nil then
		return nil
	end

	local targetTextChannel = textChannels.targetTextChannel

	if targetTextChannel ~= nil and targetTextChannel.Name ~= nil then
		return targetTextChannel.Name
	end

	local selectedChannelName = textChannels.selectedChannelName
	local v

	if FFlagExpChatUseChannelTabsStore then
		v = GetChannelTabsStore(false).getChannelTabsState(false)
	else
		v = p.ChannelTabs
	end

	if selectedChannelName ~= nil and v ~= nil and v.allChannelTabs[selectedChannelName] ~= nil or v == nil then
		return selectedChannelName
	end

	return v.selectedTabName or "RBXGeneral"
end

local function getMessageChannelName(p, p2: string?) -- 1 equivalent call inferred from this helper
	if p2 ~= nil then
		return p2 == "RBXSystem" and "RBXGeneral" or p2
	end

	if p.TextChannel == nil then
		return nil
	end

	p2 = p.TextChannel.Name

	return p2 == "RBXSystem" and "RBXGeneral" or p2
end

local function isMessageForOpenChannel(p, p2, p3: string?): boolean
	local openChannelName = getOpenChannelName(p)
	local messageChannelName = getMessageChannelName(p2, p3) -- inferred equivalent call
	return openChannelName == nil or messageChannelName == nil or messageChannelName == openChannelName
end

return isMessageForOpenChannel
