local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local function useIsMeTab(): boolean
	return useProfileWrapperContext().headerVariant == Enums.ProfileTabVariants.MeTab
end

return useIsMeTab
