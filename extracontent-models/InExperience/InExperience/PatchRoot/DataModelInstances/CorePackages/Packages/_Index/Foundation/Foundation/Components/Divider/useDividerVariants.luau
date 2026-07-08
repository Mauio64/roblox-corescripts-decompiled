local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local DividerVariant = require(Foundation.Enums.DividerVariant)
local Orientation = require(Foundation.Enums.Orientation)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 26
	-- upvalues: Orientation (copy), DividerVariant (copy)
	local t1 = {
		container = {
			tag = "col"
		},
		stroke = {
			backgroundStyle = p1.Color.Stroke.Default
		},
		line = {
			tag = "size-full-200",
			position = UDim2.fromOffset(0, p1.Size.Size_50),
			backgroundStyle = p1.Color.Common.HeavyDivider
		}
	}
	local t2 = {
		[Orientation.Horizontal] = {
			container = {
				tag = "size-full-0 auto-y"
			},
			stroke = {
				Size = UDim2.new(1, 0, 0, p1.Stroke.Standard)
			}
		},
		[Orientation.Vertical] = {
			container = {
				tag = "size-0-full auto-x"
			},
			stroke = {
				Size = UDim2.new(0, p1.Stroke.Standard, 1, 0)
			}
		}
	}
	local t3 = {
		[DividerVariant.Inset] = {
			container = {
				tag = "padding-x-xlarge"
			}
		},
		[DividerVariant.InsetLeft] = {
			container = {
				tag = "padding-left-xlarge"
			}
		},
		[DividerVariant.InsetRight] = {
			container = {
				tag = "padding-right-xlarge"
			}
		}
	}

	return {
		common = t1,
		padding = t3,
		orientation = t2
	}
end

return function(p2, p3, p4) -- line: 81
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy), Orientation (copy)
	local v14 = VariantsContext.useVariants("Divider", variantsFactory, p2)

	return composeStyleVariant(v14.common, if p4 ~= Orientation.Horizontal then {} else v14.padding[p3], v14.orientation[p4])
end
