local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialCommon")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")
local buildUserActionsComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/buildUserActionsComponent")
local module3 = require("@luauforge/bundled/feH")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useAreWebViewsSupported = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAreWebViewsSupported")
local useIsProfileQrCodeEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useIsProfileQrCodeEnabled")
local useCanRenderTransferOnProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useCanRenderTransferOnProfile")
local useCanSeeChatTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useCanSeeChatTab")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer

return function()
	local v5 = useProfileWrapperContext()

	local v6 = module3(v5, "sourceInfo.contextualInfoType")
	local v7 = useAreWebViewsSupported()
	local v8 = useIsProfileQrCodeEnabled()
	local v9 = useCanRenderTransferOnProfile()
	local v10 = useCanSeeChatTab()
	local v11 = useLocalUserId()
	local v12 = tostring(v5.profileId) == tostring(v11)

	local function fn()
		return buildUserActionsComponent(v6, {
			areWebViewsSupported = v7,
			isProfileQrCodeEnabled = v8,
			canRenderTransferInProfile = if fFlagProfilePlatformEnableCurrencyTransfer then v9 else false,
			canSeeChatTab = v10,
			isSelfView = v12
		})
	end

	return React.useMemo(fn, {
		v6,
		v7,
		v8,
		if fFlagProfilePlatformEnableCurrencyTransfer then v9 else nil,
		v10,
		v12
	})
end
