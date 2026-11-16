local Foundation = script:FindFirstAncestor("Foundation")

local ChipSize = require(Foundation.Enums.ChipSize)

local ChipVariant = require(Foundation.Enums.ChipVariant)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(data)
	local udims = {
		[ChipSize.Small] = UDim.new(0, data.Padding.Small),
		[ChipSize.Medium] = UDim.new(0, data.Padding.Medium),
		[ChipSize.Large] = UDim.new(0, data.Padding.Large)
	}

	return {
		common = {
			chip = { tag = "row align-x-center align-y-center auto-x radius-circle clip" },
			text = { tag = "shrink size-0-full auto-x text-truncate-end" }
		},
		sizes = {
			[ChipSize.Small] = {
				chip = { tag = "size-0-600" },
				text = { tag = "text-label-small" }
			},
			[ChipSize.Medium] = {
				chip = { tag = "size-0-800" },
				text = { tag = "text-label-medium" }
			},
			[ChipSize.Large] = {
				chip = { tag = "size-0-1000" },
				text = { tag = "text-label-medium" }
			}
		},
		types = {
			[ChipVariant.Utility] = {
				[true] = {
					chip = { backgroundStyle = data.Inverse.Surface.Surface_0 },
					text = { contentStyle = data.Inverse.Content.Emphasis }
				},
				[false] = {
					chip = { backgroundStyle = data.Color.ActionUtility.Background },
					text = { contentStyle = data.Color.ActionUtility.Foreground }
				}
			},
			[ChipVariant.Standard] = {
				[true] = {
					chip = { backgroundStyle = data.Inverse.Surface.Surface_0 },
					text = { contentStyle = data.Inverse.Content.Emphasis }
				},
				[false] = {
					chip = { backgroundStyle = data.Color.ActionStandard.Background },
					text = { contentStyle = data.Color.ActionStandard.Foreground }
				}
			}
		},
		textSpacing = udims
	}
end

return function(p, p2, p3, flag: boolean, flag2: boolean, flag3: boolean)
	local v = VariantsContext.useVariants("Chip", variantsFactory, p)
	local common = v.common
	local siz = v.sizes[p2]
	local v2 = v.types[p3][flag]
	local left

	if not flag2 then
		left = v.textSpacing[p2]
	end

	local right

	if not flag3 then
		right = v.textSpacing[p2]
	end

	return composeStyleVariant(common, siz, v2, {
		text = {
			padding = { left = left, right = right }
		}
	})
end
