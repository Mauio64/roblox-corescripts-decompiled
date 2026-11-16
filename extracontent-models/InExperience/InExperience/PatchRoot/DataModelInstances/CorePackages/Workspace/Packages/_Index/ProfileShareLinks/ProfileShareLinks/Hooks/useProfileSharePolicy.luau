local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local parent = ProfileShareLinks.Parent
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local ProfileSharePolicyEnum = require(ProfileShareLinks.Enums.ProfileSharePolicyEnum)

return function()
	return (useAppPolicy(function(p)
		local profileShareLinkEnabled = p.getProfileShareLinkEnabled()
		local profileCopyLinkEnabled = p.getProfileCopyLinkEnabled()

		if profileShareLinkEnabled then
			return ProfileSharePolicyEnum.Share
		end

		if profileCopyLinkEnabled then
			return ProfileSharePolicyEnum.Copy
		end

		return ProfileSharePolicyEnum.Disabled
	end))
end
