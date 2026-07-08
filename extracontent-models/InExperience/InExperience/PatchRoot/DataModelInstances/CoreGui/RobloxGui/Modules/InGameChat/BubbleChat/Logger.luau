local CorePackages = game:GetService("CorePackages")
local v2 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new("BubbleChatLogger")

return function(p1) -- line: 5
	-- upvalues: v2 (copy)
	return v2:new(p1)
end
