local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local InputSize = require(Foundation.Enums.InputSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p)
	local standard = math.ceil(p.Stroke.Standard)
	return {
		common = {
			container = {
				tag = "row align-x-left align-y-top auto-xy",
				padding = UDim.new(0, standard)
			},
			input = {
				stroke = { thickness = standard }
			}
		},
		sizes = {
			[InputSize.XSmall] = {
				container = { tag = "gap-medium" }
			},
			[InputSize.Small] = {
				container = { tag = "gap-medium" }
			},
			[InputSize.Medium] = {
				container = { tag = "gap-medium" }
			},
			[InputSize.Large] = {
				container = { tag = "gap-medium" }
			}
		},
		labelPosition = {
			[Enum.HorizontalAlignment.Left] = {
				container = { tag = "flex-x-between size-full-0" }
			},
			[Enum.HorizontalAlignment.Right] = {
				container = { tag = "" }
			}
		}
	}
end

return function(p, p2, p3)
	local v = VariantsContext.useVariants("InternalInput", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2], v.labelPosition[p3])
end
