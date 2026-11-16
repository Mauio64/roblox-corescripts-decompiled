local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)

local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local SetChannelUnreadStatus = require(ExpChat.Actions.SetChannelUnreadStatus)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local function useSignalsChannelTabUnreadWriter(p: string)
	local channelTabsStore = GetChannelTabsStore(false)
	return React.useCallback(function(flag: boolean)
		channelTabsStore.setChannelUnreadStatus(p, flag)
	end, { channelTabsStore, p })
end

local function useRoduxChannelTabUnreadWriter(p: string)
	local v = useDispatch()
	return React.useCallback(function(flag: boolean)
		v(SetChannelUnreadStatus(p, flag))
	end, { v, p })
end

if SharedFlags.FFlagExpChatUseChannelTabsStore then
	return useSignalsChannelTabUnreadWriter
end

return useRoduxChannelTabUnreadWriter
