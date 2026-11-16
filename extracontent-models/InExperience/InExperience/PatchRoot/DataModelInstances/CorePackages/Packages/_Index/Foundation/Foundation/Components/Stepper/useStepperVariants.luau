local Foundation = script:FindFirstAncestor("Foundation")

local IconSize = require(Foundation.Enums.IconSize)

local InputSize = require(Foundation.Enums.InputSize)

local StepperStepState = require(Foundation.Enums.StepperStepState)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Components.Types)

local function variantsFactory(data)
	return {
		common = {
			container = { tag = "auto-xy" },
			label = { tag = "auto-xy text-align-x-left content-emphasis" },
			description = { tag = "auto-xy text-align-x-left" },
			textColumn = { tag = "col auto-xy" },
			content = { tag = "row align-y-center auto-xy" },
			index = { tag = "auto-xy text-align-x-center text-align-y-center" },
			indicatorOuter = { tag = "row align-x-center align-y-center auto-xy" },
			indicatorInner = { tag = "row align-x-center align-y-center radius-circle" }
		},
		sizes = {
			[InputSize.XSmall] = {
				content = {
					tag = "size-0-800",
					padding = {
						left = UDim.new(0, data.Padding.XSmall),
						right = UDim.new(0, data.Padding.Small),
						top = UDim.new(0, data.Size.Size_250),
						bottom = UDim.new(0, data.Size.Size_250)
					}
				},
				textColumn = {
					padding = {
						left = UDim.new(0, data.Size.Size_250)
					}
				},
				indicatorInner = { tag = "size-300-300" },
				index = { tag = "text-caption-small" },
				label = { tag = "text-label-small" },
				description = { tag = "text-body-small" },
				icon = { size = IconSize.XSmall }
			},
			[InputSize.Small] = {
				content = {
					tag = "size-0-1000",
					padding = {
						left = UDim.new(0, data.Size.Size_150),
						right = UDim.new(0, data.Size.Size_300),
						top = UDim.new(0, data.Size.Size_300),
						bottom = UDim.new(0, data.Size.Size_300)
					}
				},
				textColumn = {
					padding = { left = UDim.new(0, data.Gap.Medium) }
				},
				indicatorInner = { tag = "size-400-400" },
				index = { tag = "text-caption-medium" },
				label = { tag = "text-label-small" },
				description = { tag = "text-body-small" },
				icon = { size = IconSize.Small }
			},
			[InputSize.Medium] = {
				content = {
					tag = "size-0-1200",
					padding = {
						left = UDim.new(0, data.Padding.Small),
						right = UDim.new(0, data.Padding.Large),
						top = UDim.new(0, data.Size.Size_350),
						bottom = UDim.new(0, data.Size.Size_350)
					}
				},
				textColumn = {
					padding = { left = UDim.new(0, data.Gap.Medium) }
				},
				indicatorInner = { tag = "size-500-500" },
				index = { tag = "text-caption-large" },
				label = { tag = "text-label-medium" },
				description = { tag = "text-body-medium" },
				icon = { size = IconSize.Medium }
			}
		},
		isFill = {
			[false] = {},
			[true] = {
				container = { tag = "grow" }
			}
		},
		stepStates = {
			[StepperStepState.Complete] = {
				indicatorInner = { tag = "bg-system-contrast" },
				description = { tag = "content-default" }
			},
			[StepperStepState.Current] = {
				indicatorInner = { tag = "bg-system-contrast" },
				description = { tag = "content-emphasis" },
				index = { tag = "content-inverse-emphasis" }
			},
			[StepperStepState.Incomplete] = {
				indicatorInner = { tag = "bg-shift-300" },
				description = { tag = "content-default" },
				index = { tag = "content-default" }
			}
		}
	}
end

return function(p, p2, p3, flag: boolean)
	local v = VariantsContext.useVariants("Stepper", variantsFactory, p)

	return composeStyleVariant(v.common, v.sizes[p2], v.isFill[flag], v.stepStates[p3])
end
