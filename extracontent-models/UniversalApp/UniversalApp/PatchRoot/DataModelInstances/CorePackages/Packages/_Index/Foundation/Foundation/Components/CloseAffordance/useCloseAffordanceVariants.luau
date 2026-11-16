local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Components.Types)

local IconSize = require(Foundation.Enums.IconSize)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)

require(Foundation.Providers.Style.Tokens)

local Constants = require(Foundation.Constants)
local getSharedVariants = require(Foundation.Components.Button.getSharedVariants)

local function fn(data)
	local sharedVariants = getSharedVariants(data)

	local sizes = {
		[true] = {
			[InputSize.XSmall] = {
				container = {
					size = UDim2.fromOffset(
						sharedVariants.sizes[InputSize.XSmall].container.height,
						sharedVariants.sizes[InputSize.XSmall].container.height
					),
					padding = UDim.new(0, data.Size.Size_100)
				},
				content = { iconSize = IconSize.Small }
			},
			[InputSize.Small] = {
				container = {
					size = UDim2.fromOffset(
						sharedVariants.sizes[InputSize.Small].container.height,
						sharedVariants.sizes[InputSize.Small].container.height
					),
					padding = UDim.new(0, data.Size.Size_150)
				},
				content = { iconSize = IconSize.Medium }
			},
			[InputSize.Medium] = {
				container = {
					size = UDim2.fromOffset(
						sharedVariants.sizes[InputSize.Medium].container.height,
						sharedVariants.sizes[InputSize.Medium].container.height
					),
					padding = UDim.new(0, data.Size.Size_200)
				},
				content = { iconSize = IconSize.Large }
			}
		},
		[false] = {
			[InputSize.XSmall] = {
				content = { iconSize = IconSize.XSmall }
			},
			[InputSize.Small] = {
				content = { iconSize = IconSize.Small }
			},
			[InputSize.Medium] = {
				content = { iconSize = IconSize.Large }
			}
		}
	}
	return {
		common = {
			container = { tag = "row align-x-center align-y-center auto-xy clip" }
		},
		types = {
			[CloseAffordanceVariant.OverMedia] = Dash.map(ColorNamespace, function()
				return {
					container = { tag = "bg-over-media-100" },
					content = { style = data.Color.Content.Emphasis }
				}
			end),
			[CloseAffordanceVariant.Utility] = Dash.map(ColorNamespace, function(p)
				return {
					container = {
						stateLayer = {
							mode = Constants.COLOR_NAMESPACE_TO_STATE_LAYER_MODE[false][p]
						}
					},
					content = { style = data[p].Content.Emphasis }
				}
			end)
		},
		sizes = sizes,
		padding = {
			[true] = {
				container = { radius = data.Radius.Medium }
			},
			[false] = {
				container = { radius = 0 }
			}
		},
		circular = {
			[true] = {
				container = { radius = data.Radius.Circle }
			},
			[false] = {}
		}
	}
end

return function(p, p2, p3, p4, flag: boolean, flag2: boolean)
	local v = VariantsContext.useVariants("CloseAffordance", fn, p)
	local v2 = p3 == CloseAffordanceVariant.OverMedia or flag2

	return composeStyleVariant(
		v.common,
		v.types[p3][p4 or ColorNamespace.Color],
		v.sizes[flag][p2],
		v.padding[flag],
		v.circular[v2]
	)
end
