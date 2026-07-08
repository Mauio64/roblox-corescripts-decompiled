local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local ProfileShareLinksParent = ProfileShareLinks.Parent
local useAppPolicy = require(ProfileShareLinksParent.UniversalAppPolicy).useAppPolicy
local ProfileSharePolicyEnum = require(ProfileShareLinks.Enums.ProfileSharePolicyEnum)

return function() -- line: 7
	-- upvalues: useAppPolicy (copy), ProfileSharePolicyEnum (copy)
	return (useAppPolicy(function(p1) -- line: 8
		-- upvalues: ProfileSharePolicyEnum (copy)
		local v6 = p1.getProfileShareLinkEnabled()
		local v7 = p1.getProfileCopyLinkEnabled()

		if v6 then
			return ProfileSharePolicyEnum.Share
		end

		if v7 then
			return ProfileSharePolicyEnum.Copy
		end

		return ProfileSharePolicyEnum.Disabled
	end))
end
