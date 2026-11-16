local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")

local function useSemanticTokens()
	local v5 = Foundation.Hooks.useTokens()

	return {
		defaultIconContainerSize = v5.Size.Size_900,
		defaultIconSize = v5.Size.Size_900,
		defaultLegacyIconSize = v5.Size.Size_600,
		closeIconSize = v5.Size.Size_600,
		activeIconBackgroundStyle = v5.Color.Shift.Shift_400,
		hoverIconBackgroundStyle = v5.Color.Shift.Shift_200,
		thumbnailBackgroundStyle = v5.Color.Surface.Surface_200,
		tooltipBackgroundStyle = v5.Color.Surface.Surface_300,
		hoverThumbnailBackgroundStyle = v5.Color.Shift.Shift_400,
		imageBorderFocusStyle = v5.Color.ActionEmphasis.Background.Color3,
		borderStrokeThickness = v5.Stroke.Standard,
		borderStrokeTransparency = 0.5,
		defaultIconTextButtonRadius = v5.Size.Size_200,
		iconTextButtonIconContainerSize = v5.Size.Size_900,
		textButtonPaddingLeft = v5.Size.Size_200,
		textButtonPaddingRight = v5.Size.Size_400,
		textButtonPaddingY = v5.Size.Size_150,
		contentForegroundStyle = v5.Color.Content.Emphasis,
		contentDisabledTransparency = 0.68,
		menuBackgroundStyle = v5.Color.OverMedia.OverMedia_0,
		defaultIconTextMenuRadius = v5.Size.Size_200,
		iconOnlyMenuItemGap = v5.Size.Size_150
	}
end

return useSemanticTokens
