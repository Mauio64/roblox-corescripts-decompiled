local CorePackages = game:GetService("CorePackages")
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new("VoiceChatLogger")

return function(p)
	return v:new(p)
end
