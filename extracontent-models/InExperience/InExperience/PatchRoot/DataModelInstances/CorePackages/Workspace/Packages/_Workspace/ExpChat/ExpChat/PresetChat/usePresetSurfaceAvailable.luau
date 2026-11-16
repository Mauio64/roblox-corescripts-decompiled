local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local SignalsReact = require(parent.SignalsReact)

local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)
local Constants = require(ExpChat.PresetChat.Constants)

local function usePresetSurfaceAvailable(p)
	local presetChatStore = GetPresetChatStore(false)
	local v = SignalsReact.useSignalState(presetChatStore.getIsEnabled)
	local v2 = SignalsReact.useSignalState(presetChatStore.getAccessLevel)

	if v and v2 == Constants.AccessLevel.Enabled then
		return (p ~= nil or FFlagExpChatUniverseChatPresetEnabled) and true or false
	end

	return false
end

return usePresetSurfaceAvailable
