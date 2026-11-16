local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local FFlagExpChatDictationContinuousByDefault = require(ExpChat.Flags.FFlagExpChatDictationContinuousByDefault)
local DictationMode = require(ExpChat.ChatInput.UI.ChatInputBar.Dictation.DictationMode)
local DictationModeSettingStorage = require(script.Parent.DictationModeSettingStorage)

local function getDefaultMode()
	if FFlagExpChatDictationContinuousByDefault then
		return DictationMode.Continuous
	end

	return DictationMode.Standard
end

return function(p)
	local v = p or DictationModeSettingStorage
	local signal, v2 = createSignal((v.read()))

	return {
		getMode = createComputed(function(p2)
			local v3 = signal(p2)

			if v3 then
				return v3
			end

			if FFlagExpChatDictationContinuousByDefault then
				return DictationMode.Continuous
			end

			return DictationMode.Standard
		end),
		setMode = function(p2)
			if signal(false) == p2 then
				return
			end

			v2(p2)
			v.write(p2)
		end
	}
end
