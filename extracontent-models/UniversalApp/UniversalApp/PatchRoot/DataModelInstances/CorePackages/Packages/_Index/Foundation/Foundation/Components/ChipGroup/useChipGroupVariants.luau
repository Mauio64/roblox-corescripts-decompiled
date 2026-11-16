local Foundation = script:FindFirstAncestor("Foundation")

local ChipSize = require(Foundation.Enums.ChipSize)

local ChipGroupVariant = require(Foundation.Enums.ChipGroupVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p)
	return {
		scrimWidth = { [ChipSize.Small] = p.Size.Size_600, [ChipSize.Medium] = p.Size.Size_800 },
		gap = { [ChipSize.Small] = p.Padding.XSmall, [ChipSize.Medium] = p.Padding.Small },
		variants = {
			[ChipGroupVariant.Row] = { isWrapped = false, hasScrim = true },
			[ChipGroupVariant.Wrap] = { isWrapped = true, hasScrim = false }
		}
	}
end

return function(p, p2, p3)
	local v = VariantsContext.useVariants("ChipGroup", variantsFactory, p)
	local variant = v.variants[p2]
	return {
		isWrapped = variant.isWrapped,
		hasScrim = variant.hasScrim,
		scrimWidth = v.scrimWidth[p3],
		gap = v.gap[p3]
	}
end
