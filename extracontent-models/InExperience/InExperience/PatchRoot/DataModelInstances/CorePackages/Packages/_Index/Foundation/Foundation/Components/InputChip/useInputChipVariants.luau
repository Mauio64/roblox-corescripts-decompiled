local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(data)
	return {
		common = {
			container = {
				tag = "row align-x-center align-y-center auto-x radius-small bg-action-standard clip"
			},
			text = {
				tag = "shrink size-0-full auto-x text-truncate-end",
				contentStyle = data.Color.ActionStandard.Foreground
			},
			close = { tag = "auto-xy" }
		},
		sizes = {
			[InputSize.XSmall] = {
				container = { tag = "size-0-400" },
				text = {
					tag = "text-caption-small",
					padding = {
						left = UDim.new(0, data.Size.Size_150),
						right = UDim.new(0, data.Padding.XSmall)
					}
				},
				close = {
					padding = {
						right = UDim.new(0, data.Size.Size_150)
					}
				}
			},
			[InputSize.Small] = {
				container = { tag = "size-0-500" },
				text = {
					tag = "text-label-small",
					padding = {
						left = UDim.new(0, data.Padding.Small),
						right = UDim.new(0, data.Size.Size_150)
					}
				},
				close = {
					padding = {
						right = UDim.new(0, data.Padding.Small)
					}
				}
			},
			[InputSize.Medium] = {
				container = { tag = "size-0-600" },
				text = {
					tag = "text-label-small",
					padding = {
						left = UDim.new(0, data.Padding.Small),
						right = UDim.new(0, data.Size.Size_150)
					}
				},
				close = {
					padding = {
						right = UDim.new(0, data.Padding.Small)
					}
				}
			},
			[InputSize.Large] = {
				container = { tag = "size-0-800" },
				text = {
					tag = "text-label-medium",
					padding = {
						left = UDim.new(0, data.Padding.Medium),
						right = UDim.new(0, data.Padding.Small)
					}
				},
				close = {
					padding = {
						right = UDim.new(0, data.Padding.Medium)
					}
				}
			}
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("InputChip", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2])
end
