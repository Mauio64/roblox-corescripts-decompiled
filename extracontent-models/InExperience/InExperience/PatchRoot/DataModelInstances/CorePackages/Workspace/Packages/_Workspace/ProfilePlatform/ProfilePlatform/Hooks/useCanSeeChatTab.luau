local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local useAppPolicy = require(ProfilePlatformParent.UniversalAppPolicy).useAppPolicy
local FFlagProfilePlatformFilterChatActionByPolicy = require(ProfilePlatform.Flags.FFlagProfilePlatformFilterChatActionByPolicy)

return function() -- line: 9
	-- upvalues: useAppPolicy (copy), FFlagProfilePlatformFilterChatActionByPolicy (copy)
	return useAppPolicy(function(p1) -- line: 10
		-- upvalues: FFlagProfilePlatformFilterChatActionByPolicy (copy)
		if FFlagProfilePlatformFilterChatActionByPolicy then
			return p1.getCanSeeChatTab()
		end

		return true
	end)
end
