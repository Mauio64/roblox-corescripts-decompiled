local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UniversalAppPolicy").useAppPolicy

return function()
	return useAppPolicy(function(p2)
		return p2.getCanSeeChatTab()
	end)
end
