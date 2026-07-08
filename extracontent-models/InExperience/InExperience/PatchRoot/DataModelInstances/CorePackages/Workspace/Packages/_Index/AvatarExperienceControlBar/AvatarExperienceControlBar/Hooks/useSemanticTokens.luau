local Parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local Foundation = require(Parent.Foundation)

local function useSemanticTokens() -- line: 6
	-- upvalues: Foundation (copy)
	local v4 = Foundation.Hooks.useTokens()

	return {
		borderStrokeTransparency = 0.5,
		contentDisabledTransparency = 0.68,
		defaultIconContainerSize = v4.Size.Size_900,
		defaultIconSize = v4.Size.Size_900,
		defaultLegacyIconSize = v4.Size.Size_600,
		closeIconSize = v4.Size.Size_600,
		activeIconBackgroundStyle = v4.Color.Shift.Shift_400,
		hoverIconBackgroundStyle = v4.Color.Shift.Shift_200,
		thumbnailBackgroundStyle = v4.Color.Surface.Surface_200,
		tooltipBackgroundStyle = v4.Color.Surface.Surface_300,
		hoverThumbnailBackgroundStyle = v4.Color.Shift.Shift_400,
		imageBorderFocusStyle = v4.Color.ActionEmphasis.Background.Color3,
		borderStrokeThickness = v4.Stroke.Standard,
		defaultIconTextButtonRadius = v4.Size.Size_200,
		iconTextButtonIconContainerSize = v4.Size.Size_900,
		textButtonPaddingLeft = v4.Size.Size_200,
		textButtonPaddingRight = v4.Size.Size_400,
		textButtonPaddingY = v4.Size.Size_150,
		contentForegroundStyle = v4.Color.Content.Emphasis,
		menuBackgroundStyle = v4.Color.OverMedia.OverMedia_0,
		defaultIconTextMenuRadius = v4.Size.Size_200,
		iconOnlyMenuItemGap = v4.Size.Size_150
	}
end

return useSemanticTokens
