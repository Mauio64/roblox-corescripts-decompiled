local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Hooks.useTokens

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useAboutSectionHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAboutSectionHeight")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")
local useCurrentlyPlayingSectionHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useCurrentlyPlayingSectionHeight")

local FFlagProfilePlatformAddCurrentlyPlaying = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformAddCurrentlyPlaying")

return function(p2, p3)
	local v5 = useTokens()
	local v6, v7 = useDynamicSizeMargin()

	local v8 = useProfileJsonComponent(Enums.Components.About)
	local v10, v11 = useAboutSectionHeight(React.useMemo(function()
		return v8.description
	end, { v8, v8.description }), p2, v6)

	local v12 = if FFlagProfilePlatformAddCurrentlyPlaying then useCurrentlyPlayingSectionHeight((useProfileJsonComponent(Enums.Components.CurrentlyPlaying))) else nil

	return (React.useMemo(function()
		local v13 = Constants.AVATAR_HEADSHOT_HEIGHT / 2 + v5.Gap.Large

		local v14 = not p3 and 0 or Constants.CONTEXTUAL_INFORMATION_HEIGHT + v5.Gap.XXLarge

		local SOCIAL_ROW_HEIGHT = Constants.SOCIAL_ROW_HEIGHT
		local CTA_BUTTON_HEIGHT = Constants.CTA_BUTTON_HEIGHT
		local v15 = (v10 == 0 and 0 or v5.Gap.XXLarge) + 10

		if FFlagProfilePlatformAddCurrentlyPlaying then
			v15 += v12 == 0 and 0 or v5.Gap.XXLarge
		end

		return p2 * 0.75 + v13 + v14 + SOCIAL_ROW_HEIGHT + v10 + CTA_BUTTON_HEIGHT + v15 + (not FFlagProfilePlatformAddCurrentlyPlaying and 0 or v12)
	end, {
		p2,
		p3,
		v10,
		v12 or 0
	}))
end
