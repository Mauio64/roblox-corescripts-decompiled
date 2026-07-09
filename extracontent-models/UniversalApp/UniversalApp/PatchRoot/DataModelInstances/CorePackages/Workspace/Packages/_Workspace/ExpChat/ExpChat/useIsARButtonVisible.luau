local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local SignalsReact = require(ExpChatParent.SignalsReact)
local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local getIsARButtonVisible = require(ExpChat.getIsARButtonVisible)

local function useIsARButtonVisible() -- line: 21
	-- upvalues: GetChatStatusStore (copy), SignalsReact (copy), GetPresetChatStore (copy), getIsARButtonVisible (copy)
	local v8 = GetChatStatusStore(false)
	local v9 = SignalsReact.useSignalState(v8.getChatStatus)
	local v10 = GetPresetChatStore(false)
	local v11 = SignalsReact.useSignalState(v10.getIsEnabled)
	local v12 = SignalsReact.useSignalState(v10.getAccessLevel)

	return getIsARButtonVisible(v9, v11, v12)
end

return useIsARButtonVisible
