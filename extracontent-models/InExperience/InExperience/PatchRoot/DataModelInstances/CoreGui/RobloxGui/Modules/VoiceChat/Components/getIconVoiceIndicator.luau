local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default

return function(s1: string, s2: string) -- line: 5
	-- upvalues: default (copy)
	return default:GetIcon(s1, s2)
end
