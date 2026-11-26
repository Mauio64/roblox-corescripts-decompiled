local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
require(CorePackages.Packages.ReactOtter)

local getFFlagConsoleApplyTokenizationEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagConsoleApplyTokenizationEdp

local function tokenSelector(p2)
	return p2.LuaApps.ExperienceDetails or {}
end

return function()
	local v5 = useDesignTokens(tokenSelector)
	local thumbnailSize = v5.ThumbnailSize
	local thumbnailMargin = v5.ThumbnailMargin
	local sideMargin = v5.SideMargin
	local headerItemPadding = v5.HeaderItemPadding
	local headerDescriptionMaxRows = v5.HeaderDescriptionMaxRows
	local headerDescriptionLineHeight = v5.HeaderDescriptionLineHeight
	local thumbnailShadowHeight = v5.ThumbnailShadowHeight
	local headerGradientHeight = v5.HeaderGradientHeight
	local headerBarBackgroundHeight = v5.HeaderBarBackgroundHeight
	local headerBottomMargin = v5.HeaderBottomMargin
	local actionBarButtonBackgroundColor = v5.ActionBarButtonBackgroundColor
	local actionBarTextButtonPadding = v5.ActionBarTextButtonPadding
	local animationConfig = v5.AnimationConfig
	local itemPadding = v5.ItemPadding
	local safeAreaSize = v5.SafeAreaSize
	local trailingWhitespace = v5.TrailingWhitespace
	local iconSize = v5.IconSize
	local expandableAreaHeightOffset = if getFFlagConsoleApplyTokenizationEdp() then v5.ExpandableAreaHeightOffset else nil

	local actionBarHeight = v5.actionBarHeight

	return React.useMemo(function()
		return {
			thumbnailSize = thumbnailSize,
			thumbnailMargin = thumbnailMargin,
			sideMargin = sideMargin,
			headerItemPadding = headerItemPadding,
			headerDescriptionMaxRows = headerDescriptionMaxRows,
			headerDescriptionLineHeight = headerDescriptionLineHeight,
			thumbnailShadowHeight = thumbnailShadowHeight,
			headerGradientHeight = headerGradientHeight,
			headerBarBackgroundHeight = headerBarBackgroundHeight,
			headerBottomMargin = headerBottomMargin,
			actionBarButtonBackgroundColor = actionBarButtonBackgroundColor and {
				Color = actionBarButtonBackgroundColor.Color3,
				Transparency = actionBarButtonBackgroundColor.Transparency
			} or nil,
			actionBarTextButtonPadding = actionBarTextButtonPadding,
			animationConfig = animationConfig,
			itemPadding = itemPadding,
			safeAreaSize = safeAreaSize,
			trailingWhitespace = trailingWhitespace,
			iconSize = iconSize,
			expandableAreaHeightOffset = expandableAreaHeightOffset,
			actionBarHeight = actionBarHeight
		}
	end, {
		thumbnailSize,
		thumbnailMargin,
		sideMargin,
		headerItemPadding,
		headerDescriptionLineHeight,
		actionBarButtonBackgroundColor,
		actionBarTextButtonPadding,
		thumbnailShadowHeight,
		headerBarBackgroundHeight,
		headerGradientHeight,
		headerBottomMargin,
		animationConfig,
		itemPadding,
		safeAreaSize,
		trailingWhitespace,
		iconSize,
		expandableAreaHeightOffset,
		actionBarHeight
	})
end
