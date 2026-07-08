local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local GetFFlagEnableAppChatInExperience = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAppChatInExperience
local GetShouldShowPlatformChatBasedOnPolicy = require(Chrome.Flags.GetShouldShowPlatformChatBasedOnPolicy)

return function() -- line: 9
	-- upvalues: GetFFlagEnableAppChatInExperience (copy), GetShouldShowPlatformChatBasedOnPolicy (copy)
	return GetFFlagEnableAppChatInExperience() and GetShouldShowPlatformChatBasedOnPolicy()
end
