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
local FFlagProfilePlatformFilterChatActionByPolicy = require(ProfilePlatform.Flags.FFlagProfilePlatformFilterChatActionByPolicy)

return function() -- line: 25
	-- upvalues: useProfileWrapperContext (copy), getDeepValue (copy), useAreWebViewsSupported (copy), useIsProfileQrCodeEnabled (copy), useCanRenderTransferOnProfile (copy), FFlagProfilePlatformFilterChatActionByPolicy (copy), useCanSeeChatTab (copy), FFlagProfilePlatformCTAsRefactor (copy), useLocalUserId (copy), React (copy), Enums (copy), getAvailableUserComponents (copy), FFlagProfilePlatformEnableVR (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), getAvailableCommunityComponents (copy), getAvailableContactComponents (copy)
	local v19 = useProfileWrapperContext()
	local profileType = v19.profileType
	local v21 = getDeepValue(v19, "sourceInfo.contextualInfoType")
	local v22 = useAreWebViewsSupported()
	local v23 = useIsProfileQrCodeEnabled()
	local v24 = useCanRenderTransferOnProfile()
	local v25 = if not FFlagProfilePlatformFilterChatActionByPolicy then nil else useCanSeeChatTab()
	local v26 = if not FFlagProfilePlatformCTAsRefactor then nil else useLocalUserId()
	local v27 = not not FFlagProfilePlatformCTAsRefactor and tostring(v19.profileId) == tostring(v26)

	return (React.useMemo(function() -- line: 40
		-- upvalues: profileType (copy), Enums (copy), getAvailableUserComponents (copy), v21 (copy), FFlagProfilePlatformEnableVR (copy), v22 (copy), v23 (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), v24 (copy), FFlagProfilePlatformFilterChatActionByPolicy (copy), v25 (copy), FFlagProfilePlatformCTAsRefactor (copy), v27 (copy), getAvailableCommunityComponents (copy), getAvailableContactComponents (copy)
		if profileType == Enums.ProfileTypes.User then
			return getAvailableUserComponents(v21, if not FFlagProfilePlatformEnableVR then {
				canRenderTransferInProfile = not not FFlagProfilePlatformEnableCurrencyTransfer and v24,
				canSeeChatTab = if not FFlagProfilePlatformFilterChatActionByPolicy then nil else v25,
				isSelfView = if not FFlagProfilePlatformCTAsRefactor then nil else v27
			} else {
				areWebViewsSupported = v22,
				isProfileQrCodeEnabled = v23,
				canRenderTransferInProfile = not not FFlagProfilePlatformEnableCurrencyTransfer and v24,
				canSeeChatTab = if not FFlagProfilePlatformFilterChatActionByPolicy then nil else v25,
				isSelfView = if not FFlagProfilePlatformCTAsRefactor then nil else v27
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
		v21,
		v22,
		v23,
		if not FFlagProfilePlatformCTAsRefactor then nil else v27,
		if not FFlagProfilePlatformEnableCurrencyTransfer then nil else v24,
		if not FFlagProfilePlatformFilterChatActionByPolicy then nil else v25
	} else {
		profileType,
		v21,
		if not FFlagProfilePlatformCTAsRefactor then nil else v27,
		if not FFlagProfilePlatformEnableCurrencyTransfer then nil else v24,
		if not FFlagProfilePlatformFilterChatActionByPolicy then nil else v25
	}))
end
