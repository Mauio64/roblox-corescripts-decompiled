local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)

return {
	get = function(p1) -- line: 8
		-- upvalues: RoactAnalytics (copy)
		local v4 = RoactAnalytics.get(p1)

		return {
			joinWithoutVoiceChat = function(p2) -- line: 16
				-- upvalues: v4 (copy)
				v4.EventStream:sendEventDeferred("voiceChat", "joinWithoutVoiceChat", {
					dontShowAgain = p2
				})
			end,
			closeEnableVoiceChatModal = function() -- line: 24
				-- upvalues: v4 (copy)
				v4.EventStream:sendEventDeferred("voiceChat", "closeEnableVoiceChatModal")
			end,
			enableVoiceChatUpsell = function() -- line: 30
				-- upvalues: v4 (copy)
				v4.EventStream:sendEventDeferred("voiceChat", "enableVoiceChatUpsell")
			end,
			showEnableVoiceChatModal = function() -- line: 36
				-- upvalues: v4 (copy)
				v4.EventStream:sendEventDeferred("voiceChat", "showEnableVoiceChatModal")
			end,
			learnMoreAboutVoiceRecordingUpsell = function() -- line: 42
				-- upvalues: v4 (copy)
				v4.EventStream:sendEventDeferred("voiceChat", "learnMoreAboutVoiceRecordingUpsell")
			end
		}
	end
}
