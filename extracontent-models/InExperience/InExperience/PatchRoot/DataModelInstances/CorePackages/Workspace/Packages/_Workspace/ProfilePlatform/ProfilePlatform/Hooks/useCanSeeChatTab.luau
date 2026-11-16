local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

return function()
	return useAppPolicy(function(p)
		return p.getCanSeeChatTab()
	end)
end
