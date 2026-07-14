local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local FFlagProfilePlatformMeTabMobileProfileHero = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformMeTabMobileProfileHero
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab
local FFlagProfilePlatformEnableAvatarBackground = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableAvatarBackground
local v9 = game:DefineFastFlag("ProfilePlatformMeTabHeroDecoupleAvatarBackground", false)

local function useShouldResizeAvatar() -- line: 16
	-- upvalues: FFlagProfilePlatformMeTabMobileProfileHero (copy), FFlagAXEnableProfileTab (copy), v9 (copy), FFlagProfilePlatformEnableAvatarBackground (copy), useProfileWrapperContext (copy), useProfileFormFactor (copy), Enums (copy)
	if not FFlagProfilePlatformMeTabMobileProfileHero then
		return false
	end

	if not FFlagAXEnableProfileTab or not v9 and not FFlagProfilePlatformEnableAvatarBackground then
		return false
	end

	local v11 = useProfileWrapperContext()
	local v12 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide

	return v11.forceFullView == true and not v12
end

return useShouldResizeAvatar
