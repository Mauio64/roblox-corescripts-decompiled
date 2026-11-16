local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Cryo = require(parent.Cryo)

require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Common.Types)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)

local FFlagProfilePlatformEnableLazyLoadingComponents = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableLazyLoadingComponents)

return function(p, data, options)
	local v = getDeepValue(p, `{data.profileId}`) or {}
	local componentOrdering

	if FFlagProfilePlatformEnableLazyLoadingComponents and data.onlyEssentialComponents then
		componentOrdering = v.componentOrdering or data.componentOrdering
	else
		componentOrdering = data.componentOrdering or v.componentOrdering
	end

	local components = v.components or {}
	local nones = {}

	for _, v2 in options or {} do
		nones[v2] = Cryo.None
	end

	local joined = Cryo.Dictionary.join(components, data.components, nones)

	local v2 = {
		profileType = data.profileType,
		profileId = data.profileId,
		componentOrdering = componentOrdering,
		components = joined
	}

	return Cryo.Dictionary.join(p, { [data.profileId] = v2 })
end
