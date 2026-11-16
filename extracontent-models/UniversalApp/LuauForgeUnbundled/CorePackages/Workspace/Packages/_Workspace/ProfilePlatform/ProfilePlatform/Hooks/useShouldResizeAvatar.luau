local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")

local fFlagProfilePlatformMeTabMobileProfileHero = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformMeTabMobileProfileHero
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab

local fFlagProfilePlatformEnableAvatarBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableAvatarBackground

local defineFastFlag = game:DefineFastFlag("ProfilePlatformMeTabHeroDecoupleAvatarBackground", false)

local function useShouldResizeAvatar(): boolean
	if not (fFlagProfilePlatformMeTabMobileProfileHero and (fFlagAXEnableProfileTab and (defineFastFlag or fFlagProfilePlatformEnableAvatarBackground))) then
		return false
	end

	local v5 = useProfileWrapperContext()
	local v6 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide

	return v5.forceFullView == true and not v6
end

return useShouldResizeAvatar
