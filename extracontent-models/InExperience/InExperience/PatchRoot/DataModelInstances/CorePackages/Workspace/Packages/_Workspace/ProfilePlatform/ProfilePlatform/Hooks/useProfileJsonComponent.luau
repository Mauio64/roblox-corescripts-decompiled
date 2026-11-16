local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Common.Enums)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileJson = require(ProfilePlatform.Hooks.useProfileJson)

return function(p)
	return getDeepValue(useProfileJson(), `components.{p}`) or {}
end
