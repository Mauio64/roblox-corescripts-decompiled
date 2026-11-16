local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local Enums = require(ProfilePlatform.Common.Enums)

local function useIsMeTab(): boolean
	return useProfileWrapperContext().headerVariant == Enums.ProfileTabVariants.MeTab
end

return useIsMeTab
