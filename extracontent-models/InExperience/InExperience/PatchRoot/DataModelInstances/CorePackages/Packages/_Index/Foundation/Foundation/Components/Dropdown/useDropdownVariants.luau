local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)

require(Foundation.Components.Types)

local ControlState = require(Foundation.Enums.ControlState)

local InputSize = require(Foundation.Enums.InputSize)

local IconSize = require(Foundation.Enums.IconSize)

require(Foundation.Enums.InputLabelSize)

local InputVariant = require(Foundation.Enums.InputVariant)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local getInputVariantsFactory = require(Foundation.Components.InputField.getInputVariantsFactory)

local function variantsFactory()
	local sizes = {
		[InputSize.XSmall] = {
			container = { tag = "gap-small size-full-600 padding-small radius-small" },
			text = { tag = "text-body-small" },
			arrow = { size = IconSize.XSmall }
		},
		[InputSize.Small] = {
			container = { tag = "gap-small size-full-800 padding-medium radius-medium" },
			text = { tag = "text-body-small" },
			arrow = { size = IconSize.Small }
		},
		[InputSize.Medium] = {
			container = { tag = "gap-small size-full-1000 padding-medium radius-medium" },
			text = { tag = "text-body-medium" },
			arrow = { size = IconSize.Medium }
		},
		[InputSize.Large] = {
			container = { tag = "gap-small size-full-1200 padding-medium radius-medium" },
			text = { tag = "text-body-large" },
			arrow = { size = IconSize.Large }
		}
	}

	local states = {
		[ControlState.Disabled] = {
			container = nil,
			text = { tag = "content-muted" }
		},
		[ControlState.Initialize] = {
			container = nil,
			text = { tag = "content-default" }
		},
		[ControlState.Default] = nil,
		[ControlState.Hover] = nil,
		[ControlState.Pressed] = nil
	}
	return {
		common = {
			container = { tag = "row flex-x-between align-y-center" },
			text = { tag = "shrink auto-xy text-truncate-split content-emphasis" }
		},
		sizes = sizes,
		states = states,
		placeholderStates = Dash.map(states, function(p)
			return Dash.join(p, {
				text = { tag = "content-muted" }
			})
		end)
	}
end

return function(p, p2, p3, p4, flag: boolean, flag2: boolean, flag3: boolean, flag4: boolean)
	local v = VariantsContext.useVariants("Dropdown", variantsFactory, p)
	local v2 = VariantsContext.useVariants("InputField", getInputVariantsFactory, p)
	local variant = v2.variants[p3 or InputVariant.Standard]

	local common = v2.common
	local common2 = v.common
	local siz = v2.sizes[p2]
	local siz2 = v.sizes[p2]
	local v3 = p3 == InputVariant.Utility and {} or variant
	local v4 = v2.hoverState[flag4]
	local v5 = v2.focusedState[flag3]
	local v6 = v2.errorState[flag2]
	local v7

	if flag then
		v7 = v.placeholderStates[p4]
	else
		v7 = v.states[p4]
	end

	return composeStyleVariant(
		common,
		common2,
		siz,
		siz2,
		v3,
		v4,
		v5,
		v6,
		v7,
		p3 ~= InputVariant.Utility and {} or variant
	)
end
