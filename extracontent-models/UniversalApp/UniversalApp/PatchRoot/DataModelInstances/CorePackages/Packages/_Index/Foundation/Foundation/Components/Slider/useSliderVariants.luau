local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

local SliderVariant = require(Foundation.Enums.SliderVariant)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

require(Foundation.Components.Types)

local Flags = require(Foundation.Utility.Flags)

local function variantsFactory(data)
	return {
		common = {
			bar = { tag = "position-center-center anchor-center-center radius-circle" },
			fill = { tag = "radius-circle" }
		},
		variants = {
			[SliderVariant.Emphasis] = {
				bar = { tag = "bg-shift-200" },
				fill = { tag = "bg-emphasis" },
				knob = {
					style = data.Color.Extended.White.White_100,
					dragStyle = data.Color.System.Emphasis,
					hasShadow = true
				}
			},
			[SliderVariant.Standard] = {
				bar = { tag = "bg-shift-200" },
				fill = { tag = "bg-system-contrast" },
				knob = {
					style = data.Color.System.Contrast,
					dragStyle = data.Color.System.Contrast,
					stroke = {
						Color = data.Color.Stroke.Default.Color3,
						Transparency = data.Color.Stroke.Default.Transparency,
						Thickness = data.Stroke.Standard
					},
					hasShadow = true
				}
			},
			[SliderVariant.Utility] = {
				knob = {
					style = data.Color.None,
					dragStyle = data.Color.None,
					stroke = {
						Color = data.Color.System.Contrast.Color3,
						Transparency = data.Color.System.Contrast.Transparency,
						Thickness = data.Stroke.Thicker
					},
					hasShadow = true
				}
			}
		},
		sizes = {
			[InputSize.XSmall] = {
				bar = { height = data.Size.Size_100 }
			},
			[InputSize.Small] = {
				bar = { height = data.Size.Size_150 }
			},
			[InputSize.Medium] = {
				bar = { height = data.Size.Size_200 }
			},
			[InputSize.Large] = {
				bar = { height = data.Size.Size_250 }
			}
		},
		orientation = {
			[true] = {
				selectionGroup = {
					SelectionBehaviorLeft = Enum.SelectionBehavior.Escape,
					SelectionBehaviorRight = Enum.SelectionBehavior.Escape,
					SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
					SelectionBehaviorDown = Enum.SelectionBehavior.Stop
				}
			},
			[false] = {
				selectionGroup = {
					SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
					SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
					SelectionBehaviorUp = Enum.SelectionBehavior.Escape,
					SelectionBehaviorDown = Enum.SelectionBehavior.Escape
				}
			}
		}
	}
end

return function(p, p2, p3, flag: boolean)
	local v = VariantsContext.useVariants("Slider", variantsFactory, p)

	if Flags.FoundationSliderCapture then
		return composeStyleVariant(v.common, v.variants[p3], v.sizes[p2])
	end

	return composeStyleVariant(v.common, v.variants[p3], v.sizes[p2], v.orientation[flag])
end
