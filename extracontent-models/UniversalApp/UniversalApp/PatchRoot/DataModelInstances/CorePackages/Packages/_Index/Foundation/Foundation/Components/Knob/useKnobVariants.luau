local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Components.Types)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local getKnobSize = require(script.Parent.getKnobSize)

local IconSize = require(Foundation.Enums.IconSize)

local function computeProps(p) -- 4 equivalent calls inferred from this helper
	return {
		knob = { size = p.size, iconSize = p.iconSize }
	}
end

local function variantsFactory(p)
	local sizes = {
		[InputSize.XSmall] = computeProps({ -- inferred equivalent call
			iconSize = IconSize.XSmall,
			size = getKnobSize(p, InputSize.XSmall)
		})
	}

	local small = InputSize.Small
	sizes[small] = computeProps({ -- inferred equivalent call
		iconSize = IconSize.Small,
		size = getKnobSize(p, InputSize.Small)
	})

	local medium = InputSize.Medium
	sizes[medium] = computeProps({ -- inferred equivalent call
		iconSize = IconSize.Small,
		size = getKnobSize(p, InputSize.Medium)
	})

	local large = InputSize.Large
	sizes[large] = computeProps({ -- inferred equivalent call
		iconSize = IconSize.Small,
		size = getKnobSize(p, InputSize.Large)
	})
	return {
		common = {
			knob = {
				tag = "align-x-center align-y-center position-center-center anchor-center-center auto-xy radius-circle"
			}
		},
		sizes = sizes,
		isInverse = {
			[false] = {
				knob = { style = p.Color.Content.Emphasis },
				iconContainer = { backgroundStyle = p.Inverse.Content.Emphasis }
			},
			[true] = {
				knob = { style = p.Inverse.Content.Emphasis },
				iconContainer = { backgroundStyle = p.Color.Content.Emphasis }
			}
		}
	}
end

return function(p, p2, flag: boolean)
	local v = VariantsContext.useVariants("Knob", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2], v.isInverse[flag])
end
