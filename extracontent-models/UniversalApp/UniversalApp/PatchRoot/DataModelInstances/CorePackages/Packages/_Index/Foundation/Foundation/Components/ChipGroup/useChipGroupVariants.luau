local Foundation = script:FindFirstAncestor("Foundation")
local ChipSize = require(Foundation.Enums.ChipSize)
local ChipGroupVariant = require(Foundation.Enums.ChipGroupVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 27
	-- upvalues: ChipSize (copy), ChipGroupVariant (copy)
	local t1 = {
		[ChipSize.Small] = p1.Size.Size_600,
		[ChipSize.Medium] = p1.Size.Size_800
	}
	local t2 = {
		[ChipSize.Small] = p1.Padding.XSmall,
		[ChipSize.Medium] = p1.Padding.Small
	}
	local t3 = {
		[ChipGroupVariant.Row] = {
			isWrapped = false,
			hasScrim = true
		},
		[ChipGroupVariant.Wrap] = {
			isWrapped = true,
			hasScrim = false
		}
	}

	return {
		scrimWidth = t1,
		gap = t2,
		variants = t3
	}
end

return function(p2, p3, p4) -- line: 56
	-- upvalues: VariantsContext (copy), variantsFactory (copy)
	local v13 = VariantsContext.useVariants("ChipGroup", variantsFactory, p2)
	local v14 = v13.variants[p3]

	return {
		isWrapped = v14.isWrapped,
		hasScrim = v14.hasScrim,
		scrimWidth = v13.scrimWidth[p4],
		gap = v13.gap[p4]
	}
end
