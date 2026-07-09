local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local LegacyBubbleChatEnabledChanged = require(Actions.LegacyBubbleChatEnabledChanged)
local LegacyBubbleChatSettingsChanged = require(Actions.LegacyBubbleChatSettingsChanged)
local LegacyDefaultSettings = require(script.Parent.LegacyDefaultSettings)

return Rodux.createReducer(LegacyDefaultSettings, {
	[LegacyBubbleChatEnabledChanged.name] = function(p1, p2) -- line: 14
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p1, {
			Enabled = p2.value
		})
	end,
	[LegacyBubbleChatSettingsChanged.name] = function(_, p4) -- line: 20
		-- upvalues: Dictionary (copy), LegacyDefaultSettings (copy)
		local chatSettings = p4.chatSettings

		if chatSettings.Transparency then
			chatSettings.BackgroundTransparency = chatSettings.Transparency
		end

		local v14 = Dictionary.join(LegacyDefaultSettings, chatSettings)

		if chatSettings and chatSettings.UserSpecificSettings then
			for k, v in pairs(chatSettings.UserSpecificSettings) do
				local v17 = Dictionary.copyDeep(LegacyDefaultSettings)

				if v.Transparency then
					v.BackgroundTransparency = v.Transparency
				end

				v17.UserSpecificSettings = nil
				v14.UserSpecificSettings[k] = Dictionary.join(v17, v)
			end
		end

		return v14
	end
})
