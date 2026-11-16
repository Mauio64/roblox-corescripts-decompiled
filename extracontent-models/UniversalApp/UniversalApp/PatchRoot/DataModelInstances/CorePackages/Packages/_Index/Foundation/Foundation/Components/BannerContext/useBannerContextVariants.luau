local Foundation = script:FindFirstAncestor("Foundation")

local BannerContextPresentation = require(Foundation.Enums.BannerContextPresentation)
local BannerContextVariant = require(Foundation.Enums.BannerContextVariant)
local IconSize = require(Foundation.Enums.IconSize)
local InputSize = require(Foundation.Enums.InputSize)
require(Foundation.Components.InternalNotice)
require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)
local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function firstLineTextPadding(data, fontSize: number) -- 2 equivalent calls inferred from this helper
	return {
		top = UDim.new(0, (math.round((data.Size.Size_600 - fontSize) / 2)))
	}
end

local function affixedContentPadding(data, p: number)
	return {
		top = UDim.new(0, p),
		right = UDim.new(0, data.Margin.Medium),
		bottom = UDim.new(0, p),
		left = UDim.new(0, data.Margin.Medium)
	}
end

local function variantsFactory(data)
	local padding = firstLineTextPadding(data, data.Typography.BodySmall.FontSize) -- inferred equivalent call
	local padding2 = firstLineTextPadding(data, data.Typography.BodyMedium.FontSize) -- inferred equivalent call

	local common = {
		content = { gap = "gap-large" },
		stack = { gap = "gap-xxsmall" },
		icon = { style = data.Color.Content.Emphasis },
		message = { tag = "content-emphasis" },
		link = { tag = "content-emphasis" }
	}

	local presentations = {
		[BannerContextPresentation.Inline] = {
			container = { tag = "radius-medium" },
			content = { tag = "padding-medium" },
			leading = { gap = "gap-small" },
			icon = { size = IconSize.Small },
			message = { tag = "text-body-small", padding = padding },
			link = { tag = "text-body-small", padding = padding, size = InputSize.Small }
		},
		[BannerContextPresentation.Affixed] = {
			leading = { gap = "gap-medium" },
			icon = { size = IconSize.Medium },
			message = { tag = "text-body-medium", padding = padding2 },
			link = { tag = "text-body-medium", padding = padding2, size = InputSize.Medium }
		}
	}

	local variants = {
		[BannerContextVariant.Standard] = {},
		[BannerContextVariant.Emphasis] = {
			container = { tag = "bg-shift-200" }
		}
	}

	local presentationVariants = {
		[BannerContextPresentation.Inline] = {
			[BannerContextVariant.Standard] = {
				container = { tag = "stroke-standard stroke-default" }
			},
			[BannerContextVariant.Emphasis] = {}
		}
	}

	local affixed = BannerContextPresentation.Affixed
	presentationVariants[affixed] = {
		[BannerContextVariant.Standard] = {
			content = {
				padding = affixedContentPadding(data, data.Padding.Large - data.Stroke.Standard)
			},
			border = {
				Size = UDim2.new(1, 0, 0, data.Stroke.Standard),
				backgroundStyle = data.Color.Stroke.Default
			}
		},
		[BannerContextVariant.Emphasis] = {
			content = {
				padding = affixedContentPadding(data, data.Padding.Large)
			}
		}
	}

	return {
		common = common,
		presentations = presentations,
		variants = variants,
		presentationVariants = presentationVariants
	}
end

local function useBannerContextVariants(p, p2, p3)
	local v = VariantsContext.useVariants("BannerContext", variantsFactory, p)
	return composeStyleVariant(v.common, v.presentations[p2], v.variants[p3], v.presentationVariants[p2][p3])
end

return useBannerContextVariants
