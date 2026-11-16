local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
require(parent.SocialCommon)

require(ProfilePlatform.Types.Component)
local buildUserActionsComponent = require(ProfilePlatform.Hooks.buildUserActionsComponent)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useAreWebViewsSupported = require(ProfilePlatform.Hooks.useAreWebViewsSupported)
local useIsProfileQrCodeEnabled = require(ProfilePlatform.Hooks.useIsProfileQrCodeEnabled)
local useCanRenderTransferOnProfile = require(ProfilePlatform.Hooks.useCanRenderTransferOnProfile)
local useCanSeeChatTab = require(ProfilePlatform.Hooks.useCanSeeChatTab)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer

return function()
	local v = useProfileWrapperContext()

	local deepValue = getDeepValue(v, "sourceInfo.contextualInfoType")
	local areWebViewsSupported = useAreWebViewsSupported()
	local isProfileQrCodeEnabled = useIsProfileQrCodeEnabled()
	local v2 = useCanRenderTransferOnProfile()
	local canSeeChatTab = useCanSeeChatTab()
	local v3 = useLocalUserId()
	local isSelfView = tostring(v.profileId) == tostring(v3)

	local useMemo = React.useMemo
	local function fn()
		local v4 = {
			areWebViewsSupported = areWebViewsSupported,
			isProfileQrCodeEnabled = isProfileQrCodeEnabled,
			canRenderTransferInProfile = nil,
			canSeeChatTab = nil,
			isSelfView = nil
		}
		local canRenderTransferInProfile

		if FFlagProfilePlatformEnableCurrencyTransfer then
			canRenderTransferInProfile = v2
		else
			canRenderTransferInProfile = false
		end

		v4.canRenderTransferInProfile = canRenderTransferInProfile

		v4.canSeeChatTab = canSeeChatTab
		v4.isSelfView = isSelfView
		return buildUserActionsComponent(deepValue, v4)
	end

	local v4

	if FFlagProfilePlatformEnableCurrencyTransfer then
		v4 = v2
	end

	return useMemo(fn, {
		deepValue,
		areWebViewsSupported,
		isProfileQrCodeEnabled,
		v4,
		canSeeChatTab,
		isSelfView
	})
end
