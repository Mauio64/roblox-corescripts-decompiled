local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)

require(ProfilePlatformParent.SocialCommon)
require(ProfilePlatform.Types.Component)

local Enums = require(ProfilePlatform.Common.Enums)
local getAvailableUserComponents = require(ProfilePlatform.Hooks.getAvailableUserComponents)
local getAvailableCommunityComponents = require(ProfilePlatform.Hooks.getAvailableCommunityComponents)
local getAvailableContactComponents = require(ProfilePlatform.Hooks.getAvailableContactComponents)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useAreWebViewsSupported = require(ProfilePlatform.Hooks.useAreWebViewsSupported)
local useIsProfileQrCodeEnabled = require(ProfilePlatform.Hooks.useIsProfileQrCodeEnabled)
local useCanRenderTransferOnProfile = require(ProfilePlatform.Hooks.useCanRenderTransferOnProfile)
local useCanSeeChatTab = require(ProfilePlatform.Hooks.useCanSeeChatTab)
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local FFlagProfilePlatformEnableVR = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableVR)
local FFlagProfilePlatformEnableCurrencyTransfer = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)

return function() -- line: 23
	-- upvalues: useProfileWrapperContext (copy), getDeepValue (copy), useAreWebViewsSupported (copy), useIsProfileQrCodeEnabled (copy), useCanRenderTransferOnProfile (copy), useCanSeeChatTab (copy), FFlagProfilePlatformCTAsRefactor (copy), useLocalUserId (copy), React (copy), Enums (copy), getAvailableUserComponents (copy), FFlagProfilePlatformEnableVR (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), getAvailableCommunityComponents (copy), getAvailableContactComponents (copy)
	local v18 = useProfileWrapperContext()
	local profileType = v18.profileType
	local v20 = getDeepValue(v18, "sourceInfo.contextualInfoType")
	local v21 = useAreWebViewsSupported()
	local v22 = useIsProfileQrCodeEnabled()
	local v23 = useCanRenderTransferOnProfile()
	local v24 = useCanSeeChatTab()
	local v25 = if not FFlagProfilePlatformCTAsRefactor then nil else useLocalUserId()
	local v26 = not not FFlagProfilePlatformCTAsRefactor and tostring(v18.profileId) == tostring(v25)

	return (React.useMemo(function() -- line: 38
		-- upvalues: profileType (copy), Enums (copy), getAvailableUserComponents (copy), v20 (copy), FFlagProfilePlatformEnableVR (copy), v21 (copy), v22 (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), v23 (copy), v24 (copy), FFlagProfilePlatformCTAsRefactor (copy), v26 (copy), getAvailableCommunityComponents (copy), getAvailableContactComponents (copy)
		if profileType == Enums.ProfileTypes.User then
			return getAvailableUserComponents(v20, if not FFlagProfilePlatformEnableVR then {
				canRenderTransferInProfile = not not FFlagProfilePlatformEnableCurrencyTransfer and v23,
				canSeeChatTab = v24,
				isSelfView = if not FFlagProfilePlatformCTAsRefactor then nil else v26
			} else {
				areWebViewsSupported = v21,
				isProfileQrCodeEnabled = v22,
				canRenderTransferInProfile = not not FFlagProfilePlatformEnableCurrencyTransfer and v23,
				canSeeChatTab = v24,
				isSelfView = if not FFlagProfilePlatformCTAsRefactor then nil else v26
			})
		end

		if profileType == Enums.ProfileTypes.Community then
			return getAvailableCommunityComponents()
		end

		if profileType == Enums.ProfileTypes.Contact then
			return getAvailableContactComponents()
		end

		return {}
	end, if not FFlagProfilePlatformEnableVR then {
		profileType,
		v20,
		v21,
		v22,
		if not FFlagProfilePlatformCTAsRefactor then nil else v26,
		if not FFlagProfilePlatformEnableCurrencyTransfer then nil else v23,
		v24
	} else {
		profileType,
		v20,
		if not FFlagProfilePlatformCTAsRefactor then nil else v26,
		if not FFlagProfilePlatformEnableCurrencyTransfer then nil else v23,
		v24
	}))
end
