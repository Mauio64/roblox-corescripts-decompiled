local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
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

local function v12(p1) -- line: 45
	-- upvalues: getSharedVariants (copy), InputSize (copy), IconSize (copy), CloseAffordanceVariant (copy), Dash (copy), ColorNamespace (copy), Constants (copy)
	local t1 = {
		container = {
			tag = "row align-x-center align-y-center auto-xy clip"
		}
	}
	local v15 = getSharedVariants(p1)
	local t2 = {
		[true] = {
			[InputSize.XSmall] = {
				container = {
					size = UDim2.fromOffset(v15.sizes[InputSize.XSmall].container.height, v15.sizes[InputSize.XSmall].container.height),
					padding = UDim.new(0, p1.Size.Size_100)
				},
				content = {
					iconSize = IconSize.Small
				}
			},
			[InputSize.Small] = {
				container = {
					size = UDim2.fromOffset(v15.sizes[InputSize.Small].container.height, v15.sizes[InputSize.Small].container.height),
					padding = UDim.new(0, p1.Size.Size_150)
				},
				content = {
					iconSize = IconSize.Medium
				}
			},
			[InputSize.Medium] = {
				container = {
					size = UDim2.fromOffset(v15.sizes[InputSize.Medium].container.height, v15.sizes[InputSize.Medium].container.height),
					padding = UDim.new(0, p1.Size.Size_200)
				},
				content = {
					iconSize = IconSize.Large
				}
			}
		},
		[false] = {
			[InputSize.XSmall] = {
				content = {
					iconSize = IconSize.XSmall
				}
			},
			[InputSize.Small] = {
				content = {
					iconSize = IconSize.Small
				}
			},
			[InputSize.Medium] = {
				content = {
					iconSize = IconSize.Large
				}
			}
		}
	}
	local t3 = {
		[CloseAffordanceVariant.OverMedia] = Dash.map(ColorNamespace, function() -- line: 101
			-- upvalues: p1 (copy)
			return {
				container = {
					tag = "bg-over-media-100"
				},
				content = {
					style = p1.Color.Content.Emphasis
				}
			}
		end),
		[CloseAffordanceVariant.Utility] = Dash.map(ColorNamespace, function(p2) -- line: 107
			-- upvalues: Constants (copy), p1 (copy)
			return {
				container = {
					stateLayer = {
						mode = Constants.COLOR_NAMESPACE_TO_STATE_LAYER_MODE[false][p2]
					}
				},
				content = {
					style = p1[p2].Content.Emphasis
				}
			}
		end)
	}
	local t4 = {
		[true] = {
			container = {
				radius = p1.Radius.Medium
			}
		},
		[false] = {
			container = {
				radius = 0
			}
		}
	}
	local t5 = {
		[true] = {
			container = {
				radius = p1.Radius.Circle
			}
		},
		[false] = {}
	}

	return {
		common = t1,
		types = t3,
		sizes = t2,
		padding = t4,
		circular = t5
	}
end

return function(p3, p4, p5, p6, b1: boolean, b2: boolean) -- line: 138
	-- upvalues: VariantsContext (copy), v12 (copy), CloseAffordanceVariant (copy), composeStyleVariant (copy), ColorNamespace (copy)
	local v26 = VariantsContext.useVariants("CloseAffordance", v12, p3)
	local v27 = p5 == CloseAffordanceVariant.OverMedia or b2

	return composeStyleVariant(v26.common, v26.types[p5][p6 or ColorNamespace.Color], v26.sizes[b1][p4], v26.padding[b1], v26.circular[v27])
end
