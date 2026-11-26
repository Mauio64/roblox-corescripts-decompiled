local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local module2 = require("@luauforge/bundled/feH")

local FFlagProfilePlatformEnableLazyLoadingComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableLazyLoadingComponents")

return function(p2, data, options)
	local v5 = module2(p2, `{data.profileId}`) or {}
	local componentOrdering

	if FFlagProfilePlatformEnableLazyLoadingComponents and data.onlyEssentialComponents then
		componentOrdering = v5.componentOrdering or data.componentOrdering
	else
		componentOrdering = data.componentOrdering or v5.componentOrdering
	end

	local components = v5.components or {}
	local nones = {}

	for k, v6 in options or {} do
		nones[v6] = Cryo.None
	end

	local joined = Cryo.Dictionary.join(components, data.components, nones)

	local v6 = {
		profileType = data.profileType,
		profileId = data.profileId,
		componentOrdering = componentOrdering,
		components = joined
	}

	return Cryo.Dictionary.join(p2, { [data.profileId] = v6 })
end
