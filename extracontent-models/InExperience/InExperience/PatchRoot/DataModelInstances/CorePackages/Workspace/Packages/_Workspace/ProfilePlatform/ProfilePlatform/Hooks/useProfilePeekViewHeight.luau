local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local useAboutSectionHeight = require(ProfilePlatform.Hooks.useAboutSectionHeight)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useCurrentlyPlayingSectionHeight = require(ProfilePlatform.Hooks.useCurrentlyPlayingSectionHeight)

local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)

return function(p: number, flag: boolean)
	local v = useTokens()
	local v2, _ = useDynamicSizeMargin()

	local v3 = useProfileJsonComponent(Enums.Components.About)
	local v4, _ = useAboutSectionHeight(React.useMemo(function()
		return v3.description
	end, { v3, v3.description }), p, v2)
	local v5

	if FFlagProfilePlatformAddCurrentlyPlaying then
		v5 = useCurrentlyPlayingSectionHeight((useProfileJsonComponent(Enums.Components.CurrentlyPlaying)))
	else
		v5 = nil
	end

	return (React.useMemo(function()
		local v6 = Constants.AVATAR_HEADSHOT_HEIGHT / 2 + v.Gap.Large

		local v7 = not flag and 0 or Constants.CONTEXTUAL_INFORMATION_HEIGHT + v.Gap.XXLarge

		local SOCIAL_ROW_HEIGHT = Constants.SOCIAL_ROW_HEIGHT
		local CTA_BUTTON_HEIGHT = Constants.CTA_BUTTON_HEIGHT
		local v8 = (v4 == 0 and 0 or v.Gap.XXLarge) + 10

		if FFlagProfilePlatformAddCurrentlyPlaying then
			v8 += v5 == 0 and 0 or v.Gap.XXLarge
		end

		return p * 0.75 + v6 + v7 + SOCIAL_ROW_HEIGHT + v4 + CTA_BUTTON_HEIGHT + v8 + (not FFlagProfilePlatformAddCurrentlyPlaying and 0 or v5)
	end, {
		p,
		flag,
		v4,
		v5 or 0
	}))
end
