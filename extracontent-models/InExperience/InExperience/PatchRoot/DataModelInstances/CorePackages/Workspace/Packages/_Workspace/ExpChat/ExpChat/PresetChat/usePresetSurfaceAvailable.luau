local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local SignalsReact = require(ExpChatParent.SignalsReact)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)
local Constants = require(ExpChat.PresetChat.Constants)

local function usePresetSurfaceAvailable(p1) -- line: 26
	-- upvalues: GetPresetChatStore (copy), SignalsReact (copy), Constants (copy), FFlagExpChatUniverseChatPresetEnabled (copy)
	local v9 = GetPresetChatStore(false)
	local v10 = SignalsReact.useSignalState(v9.getIsEnabled)
	local v11 = SignalsReact.useSignalState(v9.getAccessLevel)

	if not v10 or v11 ~= Constants.AccessLevel.Enabled then
		return false
	end

	if p1 == nil and not FFlagExpChatUniverseChatPresetEnabled then
		return false
	end

	return true
end

return usePresetSurfaceAvailable
