local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Common.Enums)

local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileJson = require(ProfilePlatform.Hooks.useProfileJson)

return function(p1) -- line: 7
	-- upvalues: useProfileJson (copy), getDeepValue (copy)
	local v5 = useProfileJson()

	return getDeepValue(v5, `components.{ p1 }`) or {}
end
