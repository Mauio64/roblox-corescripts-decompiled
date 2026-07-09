local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local useSelector = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useSelector
local Constants = require(ProfilePlatform.Common.Constants)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)

return function() -- line: 10
	-- upvalues: useProfileWrapperContext (copy), useSelector (copy), getDeepValue (copy), Constants (copy)
	local v7 = useProfileWrapperContext()
	local profileId = v7.profileId
	local profileType = v7.profileType

	return useSelector(function(p1) -- line: 15
		-- upvalues: getDeepValue (copy), Constants (copy), profileType (copy), profileId (copy)
		return getDeepValue(p1, `{ Constants.RODUX_KEY }.Profiles.{ profileType }.{ profileId }`) or {}
	end)
end
