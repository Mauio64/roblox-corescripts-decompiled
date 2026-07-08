local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.Promise)

local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default

return function() -- line: 10
	-- upvalues: default (copy)
	return default:asyncInit()
end
