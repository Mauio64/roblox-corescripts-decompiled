local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

require(parent.ExpChatShared)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)

local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignalState = SignalsReact.useSignalState

local function selectRoduxTabType(p)
	local channelTabs = p.ChannelTabs

	if channelTabs == nil or channelTabs.allChannelTabs == nil or channelTabs.selectedTabName == nil then
		return nil
	end

	local allChannelTab = channelTabs.allChannelTabs[channelTabs.selectedTabName]
	return allChannelTab and allChannelTab.Type or nil
end

local function useSelectedTabTypeFromSignals()
	return useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p)
			local channelTabsState = GetChannelTabsStore(false).getChannelTabsState(p)
			local selectedTabName = channelTabsState.selectedTabName

			if selectedTabName == nil then
				return nil
			end

			local allChannelTab = channelTabsState.allChannelTabs[selectedTabName]
			return allChannelTab and allChannelTab.type or nil
		end)
	end, {})))
end

local function useSelectedTabTypeFromRodux()
	return useSelector(selectRoduxTabType)
end

if SharedFlags.FFlagExpChatUseChannelTabsStore then
	return useSelectedTabTypeFromSignals
end

return useSelectedTabTypeFromRodux
