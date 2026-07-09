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
local FFlagProfilePlatformFilterChatActionByPolicy = require(ProfilePlatform.Flags.FFlagProfilePlatformFilterChatActionByPolicy)

return function() -- line: 23
	-- upvalues: useProfileWrapperContext (copy), getDeepValue (copy), useAreWebViewsSupported (copy), useIsProfileQrCodeEnabled (copy), useCanRenderTransferOnProfile (copy), FFlagProfilePlatformFilterChatActionByPolicy (copy), useCanSeeChatTab (copy), FFlagProfilePlatformCTAsRefactor (copy), useLocalUserId (copy), React (copy), buildUserActionsComponent (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy)
	local v15 = useProfileWrapperContext()
	local v16 = getDeepValue(v15, "sourceInfo.contextualInfoType")
	local v17 = useAreWebViewsSupported()
	local v18 = useIsProfileQrCodeEnabled()
	local v19 = useCanRenderTransferOnProfile()
	local v20 = if not FFlagProfilePlatformFilterChatActionByPolicy then nil else useCanSeeChatTab()
	local v21 = if not FFlagProfilePlatformCTAsRefactor then nil else useLocalUserId()
	local v22 = not not FFlagProfilePlatformCTAsRefactor and tostring(v15.profileId) == tostring(v21)

	return React.useMemo(function() -- line: 36
		-- upvalues: buildUserActionsComponent (copy), v16 (copy), v17 (copy), v18 (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), v19 (copy), FFlagProfilePlatformFilterChatActionByPolicy (copy), v20 (copy), FFlagProfilePlatformCTAsRefactor (copy), v22 (copy)
		return buildUserActionsComponent(v16, {
			areWebViewsSupported = v17,
			isProfileQrCodeEnabled = v18,
			canRenderTransferInProfile = not not FFlagProfilePlatformEnableCurrencyTransfer and v19,
			canSeeChatTab = if not FFlagProfilePlatformFilterChatActionByPolicy then nil else v20,
			isSelfView = if not FFlagProfilePlatformCTAsRefactor then nil else v22
		})
	end, {
		v16,
		v17,
		v18,
		if not FFlagProfilePlatformEnableCurrencyTransfer then nil else v19,
		if not FFlagProfilePlatformFilterChatActionByPolicy then nil else v20,
		if not FFlagProfilePlatformCTAsRefactor then nil else v22
	})
end
