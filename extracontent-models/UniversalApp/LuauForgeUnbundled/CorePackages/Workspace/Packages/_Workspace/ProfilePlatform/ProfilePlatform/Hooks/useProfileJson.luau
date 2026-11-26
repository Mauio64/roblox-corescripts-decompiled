local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useSelector

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local module2 = require("@luauforge/bundled/feH")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")

return function()
	local v5 = useProfileWrapperContext()
	local profileId = v5.profileId
	local profileType = v5.profileType

	return useSelector(function(p2)
		return module2(p2, `{module.RODUX_KEY}.Profiles.{profileType}.{profileId}`) or {}
	end)
end
