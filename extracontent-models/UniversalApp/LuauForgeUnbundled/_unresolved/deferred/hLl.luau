local module = require("@luauforge/bundled/dYT")

return {
	get = function(p2)
		local v5 = module.get(p2)

		return {
			joinWithoutVoiceChat = function(p3)
				v5.EventStream:sendEventDeferred("voiceChat", "joinWithoutVoiceChat", {
					dontShowAgain = p3
				})
			end,
			closeEnableVoiceChatModal = function()
				v5.EventStream:sendEventDeferred("voiceChat", "closeEnableVoiceChatModal")
			end,
			enableVoiceChatUpsell = function()
				v5.EventStream:sendEventDeferred("voiceChat", "enableVoiceChatUpsell")
			end,
			showEnableVoiceChatModal = function()
				v5.EventStream:sendEventDeferred("voiceChat", "showEnableVoiceChatModal")
			end,
			learnMoreAboutVoiceRecordingUpsell = function()
				v5.EventStream:sendEventDeferred("voiceChat", "learnMoreAboutVoiceRecordingUpsell")
			end
		}
	end
}
