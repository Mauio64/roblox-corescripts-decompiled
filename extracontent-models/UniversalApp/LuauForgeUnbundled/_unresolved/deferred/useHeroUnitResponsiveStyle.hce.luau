local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local inputSize = Foundation.Enums.InputSize
local widgetListBreakPointEnum = AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum
local getBreakpointFromRowWidth = AvatarExperienceCatalog.Utils.getBreakpointFromRowWidth

local useTokens = Foundation.Hooks.useTokens

local fFlagAXHeroUnitActionButton = AvatarExperienceFlags.FFlagAXHeroUnitActionButton

local v5 = {
	[widgetListBreakPointEnum.Default] = {
		isStacked = true,
		cardPaddingTag = "padding-medium",
		cardPaddingScale = "Medium",
		titleTag = "text-heading-small",
		descriptionTag = "text-body-medium",
		titleGroupGapTag = "gap-none",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		stackedActionButtonGapScale = "Medium",
		spotlightCardHeight = 166,
		spotlightButtonSize = inputSize.Small
	},
	[widgetListBreakPointEnum.XSmall] = {
		isStacked = true,
		cardPaddingTag = "padding-medium",
		cardPaddingScale = "Medium",
		titleTag = "text-heading-small",
		descriptionTag = "text-body-medium",
		titleGroupGapTag = "gap-none",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		stackedActionButtonGapScale = "Medium",
		spotlightCardHeight = 166,
		spotlightButtonSize = inputSize.Small
	},
	[widgetListBreakPointEnum.Small] = {
		isStacked = true,
		cardPaddingTag = "padding-medium",
		cardPaddingScale = "Medium",
		titleTag = "text-heading-small",
		descriptionTag = "text-body-medium",
		titleGroupGapTag = "gap-none",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		stackedActionButtonGapScale = "Medium",
		spotlightCardHeight = 180,
		spotlightButtonSize = inputSize.Small
	},
	[widgetListBreakPointEnum.Medium] = {
		isStacked = true,
		cardPaddingTag = "padding-xxlarge",
		cardPaddingScale = "XXLarge",
		titleTag = "text-heading-small",
		descriptionTag = "text-body-medium",
		titleGroupGapTag = "gap-xsmall",
		stackedBadgeGapTag = "gap-xlarge",
		stackedSeamScale = "medium",
		stackedActionButtonGapScale = "XXLarge",
		spotlightCardHeight = 200,
		spotlightButtonSize = inputSize.Medium
	},
	[widgetListBreakPointEnum.Large] = {
		isStacked = false,
		cardPaddingTag = "padding-xxlarge",
		cardPaddingScale = "XXLarge",
		titleTag = "text-heading-medium",
		descriptionTag = "text-body-large",
		titleGroupGapTag = "gap-xsmall",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		stackedActionButtonGapScale = "XXLarge",
		spotlightCardHeight = 225,
		spotlightButtonSize = inputSize.Medium
	},
	[widgetListBreakPointEnum.XLarge] = {
		isStacked = false,
		cardPaddingTag = "padding-xxlarge",
		cardPaddingScale = "XXLarge",
		titleTag = "text-heading-medium",
		descriptionTag = "text-body-large",
		titleGroupGapTag = "gap-xsmall",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		stackedActionButtonGapScale = "XXLarge",
		spotlightCardHeight = 225,
		spotlightButtonSize = inputSize.Medium
	},
	[widgetListBreakPointEnum.X2Large] = {
		isStacked = false,
		cardPaddingTag = "padding-xxlarge",
		cardPaddingScale = "XXLarge",
		titleTag = "text-heading-medium",
		descriptionTag = "text-body-large",
		titleGroupGapTag = "gap-xsmall",
		stackedBadgeGapTag = "gap-large",
		stackedSeamScale = "small",
		stackedActionButtonGapScale = "XXLarge",
		spotlightCardHeight = 225,
		spotlightButtonSize = inputSize.Medium
	}
}

local v6 = v5[widgetListBreakPointEnum.Default]

local function useHeroUnitResponsiveStyle(p2)
	local v7 = useTokens()
	local breakpointFromRowWidth = getBreakpointFromRowWidth(p2)

	return React.useMemo(function()
		local v8 = v5[breakpointFromRowWidth] or v6

		local v9 = {
			isStacked = v8.isStacked,
			cardPaddingTag = v8.cardPaddingTag,
			cardPaddingPx = v7.Padding[v8.cardPaddingScale],
			titleTag = v8.titleTag,
			descriptionTag = v8.descriptionTag,
			titleGroupGapTag = v8.titleGroupGapTag,
			stackedBadgeGapTag = v8.stackedBadgeGapTag,
			stackedSeamScale = v8.stackedSeamScale,
			stackedActionButtonGapPx = 0,
			spotlightCardHeight = 0,
			spotlightButtonSize = 0,
			itemGapPx = 0
		}

		local v10 = if fFlagAXHeroUnitActionButton then v7.Gap[v8.stackedActionButtonGapScale] else nil
		v9.stackedActionButtonGapPx = v10

		v9.spotlightCardHeight = v8.spotlightCardHeight
		v9.spotlightButtonSize = v8.spotlightButtonSize

		v9.itemGapPx = v7.Gap.Medium
		return v9
	end, { breakpointFromRowWidth, v7 })
end

return useHeroUnitResponsiveStyle
