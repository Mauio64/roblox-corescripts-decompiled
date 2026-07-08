local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local InputSize = require(Foundation.Enums.InputSize)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 27
	-- upvalues: InputSize (copy)
	local v7 = math.ceil(p1.Stroke.Standard)
	local t1 = {
		container = {
			tag = "row align-x-left align-y-center auto-xy",
			padding = UDim.new(0, v7)
		},
		input = {
			stroke = {
				thickness = v7
			}
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			container = {
				tag = "gap-medium"
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "gap-medium"
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "gap-medium"
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "gap-medium"
			}
		}
	}
	local t3 = {
		[Enum.HorizontalAlignment.Left] = {
			container = {
				tag = "flex-x-between size-full-0"
			}
		},
		[Enum.HorizontalAlignment.Right] = {
			container = {
				tag = ""
			}
		}
	}

	return {
		common = t1,
		sizes = t2,
		labelPosition = t3
	}
end

return function(p2, p3, p4) -- line: 52
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v14 = VariantsContext.useVariants("InternalInput", variantsFactory, p2)

	return composeStyleVariant(v14.common, v14.sizes[p3], v14.labelPosition[p4])
end
