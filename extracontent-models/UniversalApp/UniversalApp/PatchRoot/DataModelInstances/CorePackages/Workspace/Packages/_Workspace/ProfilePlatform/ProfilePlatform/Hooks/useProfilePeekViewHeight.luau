local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useTokens = require(ProfilePlatformParent.Foundation).Hooks.useTokens
local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local useAboutSectionHeight = require(ProfilePlatform.Hooks.useAboutSectionHeight)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useCurrentlyPlayingSectionHeight = require(ProfilePlatform.Hooks.useCurrentlyPlayingSectionHeight)
local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)

return function(n1: number, b1: boolean) -- line: 19
	-- upvalues: useTokens (copy), useDynamicSizeMargin (copy), useProfileJsonComponent (copy), Enums (copy), React (copy), useAboutSectionHeight (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy), useCurrentlyPlayingSectionHeight (copy), Constants (copy)
	local v14 = useTokens()
	local v15, _ = useDynamicSizeMargin()
	local v17 = useProfileJsonComponent(Enums.Components.About)
	local v18 = React.useMemo(function() -- line: 25
		-- upvalues: v17 (copy)
		return v17.description
	end, {
		v17,
		v17.description
	})
	local v19, _ = useAboutSectionHeight(v18, n1, v15)
	local u21 = nil

	if FFlagProfilePlatformAddCurrentlyPlaying then
		local v22 = useProfileJsonComponent(Enums.Components.CurrentlyPlaying)

		u21 = useCurrentlyPlayingSectionHeight(v22)
	end

	return (React.useMemo(function() -- line: 40
		-- upvalues: Constants (copy), v14 (copy), b1 (copy), v19 (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy), u21 (ref), n1 (copy)
		local v23 = Constants.AVATAR_HEADSHOT_HEIGHT / 2 + v14.Gap.Large
		local v24 = not b1 and 0 or Constants.CONTEXTUAL_INFORMATION_HEIGHT + v14.Gap.XXLarge
		local SOCIAL_ROW_HEIGHT = Constants.SOCIAL_ROW_HEIGHT
		local CTA_BUTTON_HEIGHT = Constants.CTA_BUTTON_HEIGHT
		local v27 = (v19 == 0 and 0 or v14.Gap.XXLarge) + 10

		if FFlagProfilePlatformAddCurrentlyPlaying then
			v27 += u21 == 0 and 0 or v14.Gap.XXLarge
		end

		return n1 * 0.75 + v23 + v24 + SOCIAL_ROW_HEIGHT + v19 + CTA_BUTTON_HEIGHT + v27 + (not FFlagProfilePlatformAddCurrentlyPlaying and 0 or u21)
	end, {
		n1,
		b1,
		v19,
		u21 or 0
	}))
end
