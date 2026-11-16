local parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local Foundation = require(parent.Foundation)

local function useSemanticTokens()
	local v = Foundation.Hooks.useTokens()

	return {
		defaultIconContainerSize = v.Size.Size_900,
		defaultIconSize = v.Size.Size_900,
		defaultLegacyIconSize = v.Size.Size_600,
		closeIconSize = v.Size.Size_600,
		activeIconBackgroundStyle = v.Color.Shift.Shift_400,
		hoverIconBackgroundStyle = v.Color.Shift.Shift_200,
		thumbnailBackgroundStyle = v.Color.Surface.Surface_200,
		tooltipBackgroundStyle = v.Color.Surface.Surface_300,
		hoverThumbnailBackgroundStyle = v.Color.Shift.Shift_400,
		imageBorderFocusStyle = v.Color.ActionEmphasis.Background.Color3,
		borderStrokeThickness = v.Stroke.Standard,
		borderStrokeTransparency = 0.5,
		defaultIconTextButtonRadius = v.Size.Size_200,
		iconTextButtonIconContainerSize = v.Size.Size_900,
		textButtonPaddingLeft = v.Size.Size_200,
		textButtonPaddingRight = v.Size.Size_400,
		textButtonPaddingY = v.Size.Size_150,
		contentForegroundStyle = v.Color.Content.Emphasis,
		contentDisabledTransparency = 0.68,
		menuBackgroundStyle = v.Color.OverMedia.OverMedia_0,
		defaultIconTextMenuRadius = v.Size.Size_200,
		iconOnlyMenuItemGap = v.Size.Size_150
	}
end

return useSemanticTokens
