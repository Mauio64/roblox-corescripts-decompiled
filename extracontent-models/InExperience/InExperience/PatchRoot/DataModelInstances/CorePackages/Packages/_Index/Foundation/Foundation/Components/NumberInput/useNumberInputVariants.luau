local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.NumberInputControlsVariant)

local InputSize = require(Foundation.Enums.InputSize)

local IconSize = require(Foundation.Enums.IconSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p)
	return {
		common = {
			controls = { tag = "row align-y-center bg-action-standard" }
		},
		sizes = {
			[InputSize.XSmall] = {
				controls = {
					width = p.Size.Size_1200,
					buttonSize = p.Size.Size_600,
					iconSize = IconSize.XSmall,
					tag = "radius-small",
					radius = p.Radius.Small
				}
			},
			[InputSize.Small] = {
				controls = {
					width = p.Size.Size_1600,
					buttonSize = p.Size.Size_800,
					iconSize = IconSize.Small,
					tag = "radius-medium",
					radius = p.Radius.Medium
				}
			},
			[InputSize.Medium] = {
				controls = {
					width = p.Size.Size_2000,
					buttonSize = p.Size.Size_1000,
					iconSize = IconSize.Medium,
					tag = "radius-medium",
					radius = p.Radius.Medium
				}
			},
			[InputSize.Large] = {
				controls = {
					width = p.Size.Size_2400,
					buttonSize = p.Size.Size_1200,
					iconSize = IconSize.Large,
					tag = "radius-medium",
					radius = p.Radius.Medium
				}
			}
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("NumberInput", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2])
end
