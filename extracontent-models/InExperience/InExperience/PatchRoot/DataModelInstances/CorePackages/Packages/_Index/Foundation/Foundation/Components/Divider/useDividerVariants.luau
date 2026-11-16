local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local DividerVariant = require(Foundation.Enums.DividerVariant)

local Orientation = require(Foundation.Enums.Orientation)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(data)
	local common = {
		container = { tag = "col" },
		stroke = { backgroundStyle = data.Color.Stroke.Default },
		line = {
			tag = "size-full-200",
			position = UDim2.fromOffset(0, data.Size.Size_50),
			backgroundStyle = data.Color.Common.HeavyDivider
		}
	}

	local orientation = {
		[Orientation.Horizontal] = {
			container = { tag = "size-full-0 auto-y" },
			stroke = {
				Size = UDim2.new(1, 0, 0, data.Stroke.Standard)
			}
		},
		[Orientation.Vertical] = {
			container = { tag = "size-0-full auto-x" },
			stroke = {
				Size = UDim2.new(0, data.Stroke.Standard, 1, 0)
			}
		}
	}

	return {
		common = common,
		padding = {
			[DividerVariant.Inset] = {
				container = { tag = "padding-x-xlarge" }
			},
			[DividerVariant.InsetLeft] = {
				container = { tag = "padding-left-xlarge" }
			},
			[DividerVariant.InsetRight] = {
				container = { tag = "padding-right-xlarge" }
			}
		},
		orientation = orientation
	}
end

return function(p, p2, p3)
	local v = VariantsContext.useVariants("Divider", variantsFactory, p)
	return composeStyleVariant(v.common, p3 ~= Orientation.Horizontal and {} or v.padding[p2], v.orientation[p3])
end
