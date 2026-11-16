local ExpChat = script:FindFirstAncestor("ExpChat")

local perUserAppStorage = require(ExpChat.Utils.perUserAppStorage)
local DictationMode = require(ExpChat.ChatInput.UI.ChatInputBar.Dictation.DictationMode)
local DictationModeSettingStorage = {}

function DictationModeSettingStorage.read()
	local entry = perUserAppStorage.getEntry("ExpChatDictationModeSetting")

	if entry.mode == DictationMode.Standard or entry.mode == DictationMode.Continuous then
		return entry.mode
	end

	return nil
end

function DictationModeSettingStorage.write(mode)
	perUserAppStorage.updateEntry("ExpChatDictationModeSetting", function(p)
		if p.mode == mode then
			return nil
		end

		p.mode = mode
		return p
	end)
end

return DictationModeSettingStorage
