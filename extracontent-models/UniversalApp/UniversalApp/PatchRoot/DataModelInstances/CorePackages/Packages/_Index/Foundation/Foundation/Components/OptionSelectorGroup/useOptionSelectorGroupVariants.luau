local Foundation = script:FindFirstAncestor("Foundation")

local InputLabelSize = require(Foundation.Enums.InputLabelSize)

local OptionSelectorGroupSize = require(Foundation.Enums.OptionSelectorGroupSize)

local Orientation = require(Foundation.Enums.Orientation)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(_)
	return {
		common = {
			container = { tag = "col gap-small size-full-0 auto-y" },
			list = { tag = "gap-medium size-full-0 auto-y" }
		},
		sizes = {
			[OptionSelectorGroupSize.XSmall] = {
				legend = { size = InputLabelSize.Small }
			},
			[OptionSelectorGroupSize.Small] = {
				legend = { size = InputLabelSize.Small }
			},
			[OptionSelectorGroupSize.Medium] = {
				legend = { size = InputLabelSize.Medium }
			}
		},
		orientations = {
			[Orientation.Vertical] = {
				list = {
					tag = { col = true }
				}
			},
			[Orientation.Horizontal] = {
				list = {
					tag = { row = true }
				}
			}
		}
	}
end

return function(p, p2, p3)
	local v = VariantsContext.useVariants("OptionSelectorGroup", variantsFactory, p)
	return (composeStyleVariant(v.common, v.sizes[p2], v.orientations[p3]))
end
