local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local VoiceEnabledChanged = require(RobloxGui.Modules.VoiceChat.Actions.VoiceEnabledChanged)
local BubbleChatEnabledChanged = require(script.Parent.Parent.Actions.BubbleChatEnabledChanged)

return (Rodux.createReducer({
	bubbleChatEnabled = false,
	voiceEnabled = false
}, {
	[BubbleChatEnabledChanged.name] = function(p1, p2) -- line: 16
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			bubbleChatEnabled = p2.enabled
		})
	end,
	[VoiceEnabledChanged.name] = function(p3, p4) -- line: 23
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			voiceEnabled = p4.enabled
		})
	end
}))
