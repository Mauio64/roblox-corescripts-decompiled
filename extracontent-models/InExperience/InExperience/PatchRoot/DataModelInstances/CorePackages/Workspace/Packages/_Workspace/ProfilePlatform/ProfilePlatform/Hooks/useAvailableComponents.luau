local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
require(parent.SocialCommon)

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
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local FFlagProfilePlatformEnableVR = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableVR)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer

return function()
	local v = useProfileWrapperContext()
	local profileType = v.profileType

	local deepValue = getDeepValue(v, "sourceInfo.contextualInfoType")
	local areWebViewsSupported = useAreWebViewsSupported()
	local isProfileQrCodeEnabled = useIsProfileQrCodeEnabled()
	local v2 = useCanRenderTransferOnProfile()
	local canSeeChatTab = useCanSeeChatTab()
	local v3 = useLocalUserId()
	local isSelfView = tostring(v.profileId) == tostring(v3)

	local useMemo = React.useMemo
	local function fn()
		if profileType == Enums.ProfileTypes.User then
			local v4

			if FFlagProfilePlatformEnableVR then
				v4 = {
					areWebViewsSupported = areWebViewsSupported,
					isProfileQrCodeEnabled = isProfileQrCodeEnabled,
					canRenderTransferInProfile = 0,
					canSeeChatTab = 0,
					isSelfView = 0
				}
			else
				v4 = { canRenderTransferInProfile = 0, canSeeChatTab = 0, isSelfView = 0 }
			end

			local canRenderTransferInProfile

			if FFlagProfilePlatformEnableCurrencyTransfer then
				canRenderTransferInProfile = v2
			else
				canRenderTransferInProfile = false
			end

			v4.canRenderTransferInProfile = canRenderTransferInProfile

			v4.canSeeChatTab = canSeeChatTab
			v4.isSelfView = isSelfView
			return getAvailableUserComponents(deepValue, v4)
		end

		if profileType == Enums.ProfileTypes.Community then
			return getAvailableCommunityComponents()
		end

		if profileType == Enums.ProfileTypes.Contact then
			return getAvailableContactComponents()
		end

		return {}
	end

	local v4

	if FFlagProfilePlatformEnableVR then
		v4 = { nil, nil, nil, nil, nil }
		local v5

		if FFlagProfilePlatformEnableCurrencyTransfer then
			v5 = v2
		end

		v4[1], v4[2], v4[3], v4[4], v4[5] = profileType, deepValue, isSelfView, v5, canSeeChatTab
	else
		v4 = { nil, nil, nil, nil, nil, nil, nil }
		local v5

		if FFlagProfilePlatformEnableCurrencyTransfer then
			v5 = v2
		end

		v4[1], v4[2], v4[3], v4[4], v4[5], v4[6], v4[7] = profileType, deepValue, areWebViewsSupported, isProfileQrCodeEnabled, isSelfView, v5, canSeeChatTab
	end

	return (useMemo(fn, v4))
end
