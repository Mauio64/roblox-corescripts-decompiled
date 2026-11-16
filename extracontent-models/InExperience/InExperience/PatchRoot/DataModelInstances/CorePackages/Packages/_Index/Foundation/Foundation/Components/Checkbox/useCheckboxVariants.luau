local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

require(Foundation.Components.InternalInput)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ControlState)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(data)
	return {
		common = {
			input = {
				tag = "radius-small",
				colors = { checkedStyle = data.Color.ActionSubEmphasis.Background },
				cursorRadius = UDim.new(0, data.Radius.Small)
			},
			checkmark = {
				tag = "position-center-center anchor-center-center content-action-sub-emphasis"
			}
		},
		sizes = {
			[InputSize.XSmall] = {
				input = {
					size = UDim2.fromOffset(data.Size.Size_400, data.Size.Size_400)
				},
				checkmark = { tag = "size-400" }
			},
			[InputSize.Small] = {
				input = {
					size = UDim2.fromOffset(data.Size.Size_500, data.Size.Size_500)
				},
				checkmark = { tag = "size-500" }
			},
			[InputSize.Medium] = {
				input = {
					size = UDim2.fromOffset(data.Size.Size_600, data.Size.Size_600)
				},
				checkmark = { tag = "size-600" }
			},
			[InputSize.Large] = {
				input = {
					size = UDim2.fromOffset(data.Size.Size_600, data.Size.Size_600)
				},
				checkmark = { tag = "size-600" }
			}
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("Checkbox", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2])
end
