local Foundation = script:FindFirstAncestor("Foundation")
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local IndicatorShape = require(Foundation.Enums.IndicatorShape)
local IndicatorVariant = require(Foundation.Enums.IndicatorVariant)

require(Foundation.Components.Types)

function mapToProps(p1, p2, n1: number) -- line: 29
	-- upvalues: IndicatorShape (copy)
	local uDim2 = UDim2.fromOffset(n1, n1)

	if p1 == IndicatorShape.Ring then
		return {
			indicator = {
				Image = "component_assets/circle_15_stroke_3",
				imageStyle = p2,
				Size = UDim2.fromOffset(n1, n1)
			}
		}
	end

	if p1 == IndicatorShape.Circle then
		return {
			indicator = {
				Image = "component_assets/circle_16",
				imageStyle = p2,
				Size = uDim2
			}
		}
	end

	return {
		indicator = {
			imageStyle = p2,
			Size = uDim2
		}
	}
end

local function variantsFactory(p3) -- line: 61
	-- upvalues: IndicatorVariant (copy), IndicatorShape (copy)
	local t1 = {
		[IndicatorVariant.Success] = p3.Color.System.Success,
		[IndicatorVariant.Neutral] = p3.Color.System.Neutral,
		[IndicatorVariant.Warning] = p3.Color.System.Warning,
		[IndicatorVariant.Emphasis] = p3.Color.System.Emphasis,
		[IndicatorVariant.Alert] = p3.Color.System.Alert
	}

	return {
		shapes = {
			[IndicatorShape.Circle] = {
				indicator = {
					tag = "radius-circle"
				}
			},
			[IndicatorShape.Ring] = {
				indicator = {
					tag = "radius-circle"
				}
			}
		},
		variants = t1
	}
end

return function(p4, p5, p6, n2: number) -- line: 78
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v17 = VariantsContext.useVariants("Indicator", variantsFactory, p4)

	return composeStyleVariant(v17.shapes[p5], mapToProps(p5, v17.variants[p6], n2))
end
