local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local InputSize = Foundation.Enums.InputSize
local WidgetListBreakPointEnum = AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum
local getBreakpointFromRowWidth = AvatarExperienceCatalog.Utils.getBreakpointFromRowWidth
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	[WidgetListBreakPointEnum.Default] = {
		isStacked = true,
		cardPaddingTag = "padding-medium",
		cardPaddingScale = "Medium",
		titleTag = "text-heading-small",
		descriptionTag = "text-body-medium",
		titleGroupGapTag = "gap-none",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		spotlightCardHeight = 166,
		spotlightButtonSize = InputSize.Small
	},
	[WidgetListBreakPointEnum.XSmall] = {
		isStacked = true,
		cardPaddingTag = "padding-medium",
		cardPaddingScale = "Medium",
		titleTag = "text-heading-small",
		descriptionTag = "text-body-medium",
		titleGroupGapTag = "gap-none",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		spotlightCardHeight = 166,
		spotlightButtonSize = InputSize.Small
	},
	[WidgetListBreakPointEnum.Small] = {
		isStacked = true,
		cardPaddingTag = "padding-medium",
		cardPaddingScale = "Medium",
		titleTag = "text-heading-small",
		descriptionTag = "text-body-medium",
		titleGroupGapTag = "gap-none",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		spotlightCardHeight = 180,
		spotlightButtonSize = InputSize.Small
	},
	[WidgetListBreakPointEnum.Medium] = {
		isStacked = true,
		cardPaddingTag = "padding-xxlarge",
		cardPaddingScale = "XXLarge",
		titleTag = "text-heading-small",
		descriptionTag = "text-body-medium",
		titleGroupGapTag = "gap-xsmall",
		stackedBadgeGapTag = "gap-xlarge",
		stackedSeamScale = "medium",
		spotlightCardHeight = 200,
		spotlightButtonSize = InputSize.Medium
	},
	[WidgetListBreakPointEnum.Large] = {
		isStacked = false,
		cardPaddingTag = "padding-xxlarge",
		cardPaddingScale = "XXLarge",
		titleTag = "text-heading-medium",
		descriptionTag = "text-body-large",
		titleGroupGapTag = "gap-xsmall",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		spotlightCardHeight = 225,
		spotlightButtonSize = InputSize.Medium
	},
	[WidgetListBreakPointEnum.XLarge] = {
		isStacked = false,
		cardPaddingTag = "padding-xxlarge",
		cardPaddingScale = "XXLarge",
		titleTag = "text-heading-medium",
		descriptionTag = "text-body-large",
		titleGroupGapTag = "gap-xsmall",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		spotlightCardHeight = 225,
		spotlightButtonSize = InputSize.Medium
	},
	[WidgetListBreakPointEnum.X2Large] = {
		isStacked = false,
		cardPaddingTag = "padding-xxlarge",
		cardPaddingScale = "XXLarge",
		titleTag = "text-heading-medium",
		descriptionTag = "text-body-large",
		titleGroupGapTag = "gap-xsmall",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		spotlightCardHeight = 225,
		spotlightButtonSize = InputSize.Medium
	}
}
local v10 = t1[WidgetListBreakPointEnum.Default]

local function useHeroUnitResponsiveStyle(n1: number) -- line: 143
	-- upvalues: useTokens (copy), getBreakpointFromRowWidth (copy), React (copy), t1 (copy), v10 (copy)
	local v13 = useTokens()
	local v14 = getBreakpointFromRowWidth(n1)

	return React.useMemo(function() -- line: 147
		-- upvalues: t1 (copy), v14 (copy), v10 (copy), v13 (copy)
		local v15 = t1[v14] or v10

		return {
			isStacked = v15.isStacked,
			cardPaddingTag = v15.cardPaddingTag,
			cardPaddingPx = v13.Padding[v15.cardPaddingScale],
			titleTag = v15.titleTag,
			descriptionTag = v15.descriptionTag,
			titleGroupGapTag = v15.titleGroupGapTag,
			stackedBadgeGapTag = v15.stackedBadgeGapTag,
			stackedSeamScale = v15.stackedSeamScale,
			spotlightCardHeight = v15.spotlightCardHeight,
			spotlightButtonSize = v15.spotlightButtonSize,
			itemGapPx = v13.Gap.Medium
		}
	end, {
		v14,
		v13
	})
end

return useHeroUnitResponsiveStyle
