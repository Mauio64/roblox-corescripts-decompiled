local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local LegacyBubbleChatEnabledChanged = require(Actions.LegacyBubbleChatEnabledChanged)
local LegacyBubbleChatSettingsChanged = require(Actions.LegacyBubbleChatSettingsChanged)

local LegacyDefaultSettings = require(script.Parent.LegacyDefaultSettings)

return Rodux.createReducer(LegacyDefaultSettings, {
	[LegacyBubbleChatEnabledChanged.name] = function(p, p2)
		return dictionary.join(p, { Enabled = p2.value })
	end,
	[LegacyBubbleChatSettingsChanged.name] = function(_, p)
		local chatSettings = p.chatSettings

		if chatSettings.Transparency then
			chatSettings.BackgroundTransparency = chatSettings.Transparency
		end

		local joined = dictionary.join(LegacyDefaultSettings, chatSettings)

		if chatSettings and chatSettings.UserSpecificSettings then
			for k, userSpecificSetting in pairs(chatSettings.UserSpecificSettings) do
				local copyDeep = dictionary.copyDeep(LegacyDefaultSettings)

				if userSpecificSetting.Transparency then
					userSpecificSetting.BackgroundTransparency = userSpecificSetting.Transparency
				end

				copyDeep.UserSpecificSettings = nil
				joined.UserSpecificSettings[k] = dictionary.join(copyDeep, userSpecificSetting)
			end
		end

		return joined
	end
})
