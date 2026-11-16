local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformMeTabMobileProfileHero = SharedFlags.FFlagProfilePlatformMeTabMobileProfileHero
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags2.FFlagAXEnableProfileTab

local SharedFlags3 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableAvatarBackground = SharedFlags3.FFlagProfilePlatformEnableAvatarBackground

local defineFastFlag = game:DefineFastFlag("ProfilePlatformMeTabHeroDecoupleAvatarBackground", false)

local function useShouldResizeAvatar(): boolean
	if not (FFlagProfilePlatformMeTabMobileProfileHero and (FFlagAXEnableProfileTab and (defineFastFlag or FFlagProfilePlatformEnableAvatarBackground))) then
		return false
	end

	local v = useProfileWrapperContext()
	local v2 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide

	return v.forceFullView == true and not v2
end

return useShouldResizeAvatar
