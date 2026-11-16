local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialCommon")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local getAvailableUserComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getAvailableUserComponents")
local getAvailableCommunityComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getAvailableCommunityComponents")
local getAvailableContactComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getAvailableContactComponents")
local module6 = require("@luauforge/bundled/eXH")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useAreWebViewsSupported = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAreWebViewsSupported")
local useIsProfileQrCodeEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useIsProfileQrCodeEnabled")
local useCanRenderTransferOnProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useCanRenderTransferOnProfile")
local useCanSeeChatTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useCanSeeChatTab")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId
local FFlagProfilePlatformEnableVR = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableVR")

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer

return function()
	local v5 = useProfileWrapperContext()
	local profileType = v5.profileType

	local v6 = module6(v5, "sourceInfo.contextualInfoType")
	local v7 = useAreWebViewsSupported()
	local v8 = useIsProfileQrCodeEnabled()
	local v9 = useCanRenderTransferOnProfile()
	local v10 = useCanSeeChatTab()
	local v11 = useLocalUserId()
	local v12 = tostring(v5.profileId) == tostring(v11)

	local useMemo = React.useMemo
	local function fn()
		if profileType == Enums.ProfileTypes.User then
			local v15

			if FFlagProfilePlatformEnableVR then
				v15 = {
					areWebViewsSupported = v7,
					isProfileQrCodeEnabled = v8,
					canRenderTransferInProfile = 0,
					canSeeChatTab = 0,
					isSelfView = 0
				}
			else
				v15 = {
					canRenderTransferInProfile = 0,
					canSeeChatTab = 0,
					isSelfView = 0
				}
			end

			v15.canRenderTransferInProfile = if fFlagProfilePlatformEnableCurrencyTransfer then v9 else false

			v15.canSeeChatTab = v10
			v15.isSelfView = v12
			return getAvailableUserComponents(v6, v15)
		end

		if profileType == Enums.ProfileTypes.Community then
			return getAvailableCommunityComponents()
		end

		if profileType == Enums.ProfileTypes.Contact then
			return getAvailableContactComponents()
		end

		return {}
	end

	local v13

	if FFlagProfilePlatformEnableVR then
		v13 = { nil, nil, nil, nil, nil }

		v13[1], v13[2], v13[3], v13[4], v13[5] = profileType, v6, v12, if fFlagProfilePlatformEnableCurrencyTransfer then v9 else nil, v10
	else
		v13 = { nil, nil, nil, nil, nil, nil, nil }

		v13[1], v13[2], v13[3], v13[4], v13[5], v13[6], v13[7] = profileType, v6, v7, v8, v12, if fFlagProfilePlatformEnableCurrencyTransfer then v9 else nil, v10
	end

	return (useMemo(fn, v13))
end
