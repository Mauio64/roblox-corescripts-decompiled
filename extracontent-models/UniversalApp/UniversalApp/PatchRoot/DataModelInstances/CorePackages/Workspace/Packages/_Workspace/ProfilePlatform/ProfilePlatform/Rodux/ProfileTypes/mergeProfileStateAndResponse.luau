local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Cryo = require(ProfilePlatformParent.Cryo)

require(ProfilePlatform.Common.Types)

local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local FFlagProfilePlatformEnableLazyLoadingComponents = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableLazyLoadingComponents)

return function(p1, p2) -- line: 11
	-- upvalues: getDeepValue (copy), FFlagProfilePlatformEnableLazyLoadingComponents (copy), Cryo (copy)
	local v8 = getDeepValue(p1, `{ p2.profileId }`) or {}
	local v9 = if not FFlagProfilePlatformEnableLazyLoadingComponents or not p2.onlyEssentialComponents then p2.componentOrdering or v8.componentOrdering else v8.componentOrdering or p2.componentOrdering
	local v10 = v8.components or {}
	local v11 = Cryo.Dictionary.join(v10, p2.components)
	local t1 = {
		profileType = p2.profileType,
		profileId = p2.profileId,
		componentOrdering = v9,
		components = v11
	}

	return Cryo.Dictionary.join(p1, {
		[p2.profileId] = t1
	})
end
