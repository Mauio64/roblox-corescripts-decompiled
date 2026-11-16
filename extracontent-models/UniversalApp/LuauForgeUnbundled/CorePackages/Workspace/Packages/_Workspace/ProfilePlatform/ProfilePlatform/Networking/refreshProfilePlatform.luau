local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")

function LUAUFORGE_MODULE_GLOBALS_eYB_refreshProfilePlatform(data)
	local mapped = Cryo.List.map(data.components, function(p2)
		local v5 = { component = p2 }

		if p2 == Enums.Components.Actions then
			v5.isActionsV2Supported = true
		end

		return v5
	end)

	return getProfilePlatform.API({
		profileType = data.profileType,
		profileId = data.profileId,
		components = mapped,
		includeComponentOrdering = false
	})
end

return LUAUFORGE_MODULE_GLOBALS_eYB_refreshProfilePlatform
