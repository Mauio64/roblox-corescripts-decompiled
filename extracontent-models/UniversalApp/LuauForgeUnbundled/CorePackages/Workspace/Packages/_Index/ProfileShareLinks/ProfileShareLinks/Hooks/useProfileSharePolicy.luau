local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/UniversalAppPolicy").useAppPolicy

local ProfileSharePolicyEnum = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Enums/ProfileSharePolicyEnum")

return function()
	return (useAppPolicy(function(p2)
		local profileShareLinkEnabled = p2.getProfileShareLinkEnabled()
		local profileCopyLinkEnabled = p2.getProfileCopyLinkEnabled()

		if profileShareLinkEnabled then
			return ProfileSharePolicyEnum.Share
		end

		if profileCopyLinkEnabled then
			return ProfileSharePolicyEnum.Copy
		end

		return ProfileSharePolicyEnum.Disabled
	end))
end
