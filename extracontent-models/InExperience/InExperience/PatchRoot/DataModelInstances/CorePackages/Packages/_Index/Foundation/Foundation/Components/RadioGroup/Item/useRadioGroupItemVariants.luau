local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.InternalInput)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ControlState)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(data)
	return {
		common = {
			input = {
				tag = "radius-circle",
				cursorRadius = UDim.new(0, data.Radius.Circle)
			},
			checkmark = {
				tag = "position-center-center anchor-center-center radius-circle",
				style = data.Inverse.Content.Emphasis
			}
		},
		sizes = {
			[InputSize.XSmall] = {
				input = {
					size = UDim2.fromOffset(data.Size.Size_400, data.Size.Size_400)
				},
				checkmark = { tag = "size-150" }
			},
			[InputSize.Small] = {
				input = {
					size = UDim2.fromOffset(data.Size.Size_500, data.Size.Size_500)
				},
				checkmark = { tag = "size-200" }
			},
			[InputSize.Medium] = {
				input = {
					size = UDim2.fromOffset(data.Size.Size_600, data.Size.Size_600)
				},
				checkmark = { tag = "size-250" }
			},
			[InputSize.Large] = {
				input = {
					size = UDim2.fromOffset(data.Size.Size_600, data.Size.Size_600)
				},
				checkmark = { tag = "size-250" }
			}
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("RadioItem", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2])
end
