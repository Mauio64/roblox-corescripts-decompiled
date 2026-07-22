local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)

require(ProfilePlatformParent.SocialCommon)
require(ProfilePlatform.Types.Component)

local buildUserActionsComponent = require(ProfilePlatform.Hooks.buildUserActionsComponent)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useAreWebViewsSupported = require(ProfilePlatform.Hooks.useAreWebViewsSupported)
local useIsProfileQrCodeEnabled = require(ProfilePlatform.Hooks.useIsProfileQrCodeEnabled)
local useCanRenderTransferOnProfile = require(ProfilePlatform.Hooks.useCanRenderTransferOnProfile)
local useCanSeeChatTab = require(ProfilePlatform.Hooks.useCanSeeChatTab)
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local FFlagProfilePlatformEnableCurrencyTransfer = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)

return function() -- line: 21
	-- upvalues: useProfileWrapperContext (copy), getDeepValue (copy), useAreWebViewsSupported (copy), useIsProfileQrCodeEnabled (copy), useCanRenderTransferOnProfile (copy), useCanSeeChatTab (copy), FFlagProfilePlatformCTAsRefactor (copy), useLocalUserId (copy), React (copy), buildUserActionsComponent (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy)
	local v14 = useProfileWrapperContext()
	local v15 = getDeepValue(v14, "sourceInfo.contextualInfoType")
	local v16 = useAreWebViewsSupported()
	local v17 = useIsProfileQrCodeEnabled()
	local v18 = useCanRenderTransferOnProfile()
	local v19 = useCanSeeChatTab()
	local v20 = if not FFlagProfilePlatformCTAsRefactor then nil else useLocalUserId()
	local v21 = not not FFlagProfilePlatformCTAsRefactor and tostring(v14.profileId) == tostring(v20)

	return React.useMemo(function() -- line: 34
		-- upvalues: buildUserActionsComponent (copy), v15 (copy), v16 (copy), v17 (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), v18 (copy), v19 (copy), FFlagProfilePlatformCTAsRefactor (copy), v21 (copy)
		return buildUserActionsComponent(v15, {
			areWebViewsSupported = v16,
			isProfileQrCodeEnabled = v17,
			canRenderTransferInProfile = not not FFlagProfilePlatformEnableCurrencyTransfer and v18,
			canSeeChatTab = v19,
			isSelfView = if not FFlagProfilePlatformCTAsRefactor then nil else v21
		})
	end, {
		v15,
		v16,
		v17,
		if not FFlagProfilePlatformEnableCurrencyTransfer then nil else v18,
		v19,
		if not FFlagProfilePlatformCTAsRefactor then nil else v21
	})
end
