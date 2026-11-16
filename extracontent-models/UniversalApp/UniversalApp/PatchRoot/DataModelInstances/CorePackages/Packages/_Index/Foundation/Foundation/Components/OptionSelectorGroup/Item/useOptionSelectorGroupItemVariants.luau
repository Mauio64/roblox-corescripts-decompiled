local Foundation = script:FindFirstAncestor("Foundation")

local IconSize = require(Foundation.Enums.IconSize)

require(Foundation.Enums.InputSize)

local OptionSelectorGroupSize = require(Foundation.Enums.OptionSelectorGroupSize)

local FillBehavior = require(Foundation.Enums.FillBehavior)

local Orientation = require(Foundation.Enums.Orientation)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function groupSizeVariantsFactory(data)
	local common = {
		container = { tag = "col align-x-left align-y-center gap-xsmall" },
		content = data.Color.Content.Emphasis,
		supportingContent = data.Color.Content.Default,
		label = { tag = "content-emphasis" },
		metadata = { tag = "content-default" },
		description = { tag = "content-default" }
	}

	local v = {
		container = { tag = "padding-xlarge radius-medium", radius = data.Radius.Medium },
		icon = { size = IconSize.Medium, extent = data.Size.Size_500 },
		label = { tag = "text-title-medium" },
		metadata = { tag = "text-caption-medium" },
		description = { tag = "text-body-medium" }
	}

	local v2 = {
		container = { tag = "padding-large radius-medium", radius = data.Radius.Medium },
		icon = { size = IconSize.Small, extent = data.Size.Size_400 },
		label = { tag = "text-title-small" },
		metadata = { tag = "text-caption-small" },
		description = { tag = "text-body-small" }
	}

	local v3 = {
		container = { tag = "padding-medium radius-small", radius = data.Radius.Small },
		icon = { size = IconSize.XSmall, extent = data.Size.Size_300 },
		label = { tag = "text-title-small" },
		metadata = { tag = "text-caption-small" },
		description = { tag = "text-body-small" }
	}

	local v4 = {
		label = { tag = "size-full-0 auto-y" },
		metadata = { tag = "size-full-0 auto-y" },
		description = { tag = "size-full-0 auto-y" }
	}
	return {
		common = common,
		sizes = {
			[OptionSelectorGroupSize.XSmall] = v3,
			[OptionSelectorGroupSize.Small] = v2,
			[OptionSelectorGroupSize.Medium] = v
		},
		layouts = {
			Inline = composeStyleVariant({
				container = { tag = "size-full-0 auto-y" },
				itemInner = { tag = "row align-y-center gap-small size-full-0 auto-y" },
				textContainer = { tag = "col fill gap-xsmall size-full-0 auto-y" }
			}, v4),
			StackedFill = composeStyleVariant({
				container = { tag = "fill auto-y" },
				itemInner = { tag = "col gap-small size-full-0 auto-y" },
				textContainer = { tag = "col gap-xsmall size-full-0 auto-y" }
			}, v4),
			StackedFit = composeStyleVariant({
				container = { tag = "auto-xy" },
				itemInner = { tag = "col gap-small auto-xy" },
				textContainer = { tag = "col gap-xsmall auto-xy" }
			}, {
				label = { tag = "auto-xy" },
				metadata = { tag = "auto-xy" },
				description = { tag = "auto-xy" }
			})
		},
		selection = {
			[false] = {
				container = { stroke = data.Color.Stroke.Emphasis }
			},
			[true] = {
				container = { stroke = data.Color.System.Contrast }
			}
		}
	}
end

local function variantsFactory(p)
	return { groupSize = groupSizeVariantsFactory(p) }
end

return function(p, p2, p3, p4, flag: boolean?)
	local groupSize = VariantsContext.useVariants("OptionSelectorGroupItem", variantsFactory, p).groupSize
	local v

	if p3 == Orientation.Vertical then
		v = p4 == FillBehavior.Fit
	else
		v = false
	end

	local v2

	if p3 == Orientation.Horizontal then
		v2 = groupSize.layouts.Inline
	elseif v then
		v2 = groupSize.layouts.StackedFit
	else
		v2 = groupSize.layouts.StackedFill
	end

	return (composeStyleVariant(groupSize.common, groupSize.sizes[p2], v2, groupSize.selection[flag == true]))
end
