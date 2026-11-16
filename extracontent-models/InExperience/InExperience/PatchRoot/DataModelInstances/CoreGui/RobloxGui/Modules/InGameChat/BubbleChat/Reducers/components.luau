local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local VoiceEnabledChanged = require(RobloxGui.Modules.VoiceChat.Actions.VoiceEnabledChanged)
local BubbleChatEnabledChanged = require(script.Parent.Parent.Actions.BubbleChatEnabledChanged)

return (Rodux.createReducer({ bubbleChatEnabled = false, voiceEnabled = false }, {
	[BubbleChatEnabledChanged.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { bubbleChatEnabled = p2.enabled })
	end,
	[VoiceEnabledChanged.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { voiceEnabled = p2.enabled })
	end
}))
