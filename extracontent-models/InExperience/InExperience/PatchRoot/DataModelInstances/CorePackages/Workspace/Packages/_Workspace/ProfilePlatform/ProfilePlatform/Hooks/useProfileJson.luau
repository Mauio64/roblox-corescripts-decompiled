local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Constants = require(ProfilePlatform.Common.Constants)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)

return function()
	local v = useProfileWrapperContext()
	local profileId = v.profileId
	local profileType = v.profileType

	return useSelector(function(p)
		return getDeepValue(p, `{Constants.RODUX_KEY}.Profiles.{profileType}.{profileId}`) or {}
	end)
end
