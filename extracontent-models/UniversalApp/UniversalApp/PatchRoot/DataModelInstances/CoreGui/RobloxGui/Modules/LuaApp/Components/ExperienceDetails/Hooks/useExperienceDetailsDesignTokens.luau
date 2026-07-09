local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens

require(CorePackages.Packages.ReactOtter)

local GetFFlagConsoleApplyTokenizationEdp = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagConsoleApplyTokenizationEdp

local function tokenSelector(p1) -- line: 10
	return p1.LuaApps.ExperienceDetails or {}
end

return function() -- line: 36
	-- upvalues: useDesignTokens (copy), tokenSelector (copy), GetFFlagConsoleApplyTokenizationEdp (copy), React (copy)
	local v7 = useDesignTokens(tokenSelector)
	local ThumbnailSize = v7.ThumbnailSize
	local ThumbnailMargin = v7.ThumbnailMargin
	local SideMargin = v7.SideMargin
	local HeaderItemPadding = v7.HeaderItemPadding
	local HeaderDescriptionMaxRows = v7.HeaderDescriptionMaxRows
	local HeaderDescriptionLineHeight = v7.HeaderDescriptionLineHeight
	local ThumbnailShadowHeight = v7.ThumbnailShadowHeight
	local HeaderGradientHeight = v7.HeaderGradientHeight
	local HeaderBarBackgroundHeight = v7.HeaderBarBackgroundHeight
	local HeaderBottomMargin = v7.HeaderBottomMargin
	local ActionBarButtonBackgroundColor = v7.ActionBarButtonBackgroundColor
	local ActionBarTextButtonPadding = v7.ActionBarTextButtonPadding
	local AnimationConfig = v7.AnimationConfig
	local ItemPadding = v7.ItemPadding
	local SafeAreaSize = v7.SafeAreaSize
	local TrailingWhitespace = v7.TrailingWhitespace
	local IconSize = v7.IconSize
	local v25 = if not GetFFlagConsoleApplyTokenizationEdp() then nil else v7.ExpandableAreaHeightOffset
	local actionBarHeight = v7.actionBarHeight

	return React.useMemo(function() -- line: 61
		-- upvalues: ThumbnailSize (copy), ThumbnailMargin (copy), SideMargin (copy), HeaderItemPadding (copy), HeaderDescriptionMaxRows (copy), HeaderDescriptionLineHeight (copy), ThumbnailShadowHeight (copy), HeaderGradientHeight (copy), HeaderBarBackgroundHeight (copy), HeaderBottomMargin (copy), ActionBarButtonBackgroundColor (copy), ActionBarTextButtonPadding (copy), AnimationConfig (copy), ItemPadding (copy), SafeAreaSize (copy), TrailingWhitespace (copy), IconSize (copy), v25 (copy), actionBarHeight (copy)
		return {
			thumbnailSize = ThumbnailSize,
			thumbnailMargin = ThumbnailMargin,
			sideMargin = SideMargin,
			headerItemPadding = HeaderItemPadding,
			headerDescriptionMaxRows = HeaderDescriptionMaxRows,
			headerDescriptionLineHeight = HeaderDescriptionLineHeight,
			thumbnailShadowHeight = ThumbnailShadowHeight,
			headerGradientHeight = HeaderGradientHeight,
			headerBarBackgroundHeight = HeaderBarBackgroundHeight,
			headerBottomMargin = HeaderBottomMargin,
			actionBarButtonBackgroundColor = if not ActionBarButtonBackgroundColor then nil else {
				Color = ActionBarButtonBackgroundColor.Color3,
				Transparency = ActionBarButtonBackgroundColor.Transparency
			},
			actionBarTextButtonPadding = ActionBarTextButtonPadding,
			animationConfig = AnimationConfig,
			itemPadding = ItemPadding,
			safeAreaSize = SafeAreaSize,
			trailingWhitespace = TrailingWhitespace,
			iconSize = IconSize,
			expandableAreaHeightOffset = v25,
			actionBarHeight = actionBarHeight
		}
	end, {
		ThumbnailSize,
		ThumbnailMargin,
		SideMargin,
		HeaderItemPadding,
		HeaderDescriptionLineHeight,
		ActionBarButtonBackgroundColor,
		ActionBarTextButtonPadding,
		ThumbnailShadowHeight,
		HeaderBarBackgroundHeight,
		HeaderGradientHeight,
		HeaderBottomMargin,
		AnimationConfig,
		ItemPadding,
		SafeAreaSize,
		TrailingWhitespace,
		IconSize,
		v25,
		actionBarHeight
	})
end
