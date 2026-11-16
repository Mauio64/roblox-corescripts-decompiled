local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local SignalsReact = require(parent.SignalsReact)

local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local getIsARButtonVisible = require(ExpChat.getIsARButtonVisible)

local function useIsARButtonVisible()
	local chatStatusStore = GetChatStatusStore(false)
	local v = SignalsReact.useSignalState(chatStatusStore.getChatStatus)

	local presetChatStore = GetPresetChatStore(false)
	return getIsARButtonVisible(
		v,
		SignalsReact.useSignalState(presetChatStore.getIsEnabled),
		(SignalsReact.useSignalState(presetChatStore.getAccessLevel))
	)
end

return useIsARButtonVisible
