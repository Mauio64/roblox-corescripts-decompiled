local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)

require(Foundation.Components.Types)

local ControlState = require(Foundation.Enums.ControlState)
local InputSize = require(Foundation.Enums.InputSize)
local IconSize = require(Foundation.Enums.IconSize)

require(Foundation.Enums.InputLabelSize)

local InputVariant = require(Foundation.Enums.InputVariant)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local getInputVariantsFactory = require(Foundation.Components.InputField.getInputVariantsFactory)

local function variantsFactory() -- line: 49
	-- upvalues: Flags (copy), InputSize (copy), IconSize (copy), ControlState (copy), Dash (copy)
	local t1 = {
		container = {
			tag = {
				["row flex-x-between align-y-center stroke-standard stroke-position-inner"] = not Flags.FoundationDropdownVariant,
				["row flex-x-between align-y-center"] = Flags.FoundationDropdownVariant
			}
		},
		text = {
			tag = {
				["shrink auto-xy text-truncate-split content-emphasis"] = Flags.FoundationDropdownVariant,
				["shrink auto-xy text-truncate-split"] = not Flags.FoundationDropdownVariant
			}
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			container = {
				tag = {
					["gap-small size-full-600 padding-small radius-small"] = Flags.FoundationDropdownSizeGap,
					["gap-xxsmall size-full-600 padding-small radius-small"] = not Flags.FoundationDropdownSizeGap
				}
			},
			text = {
				tag = "text-body-small"
			},
			arrow = {
				size = IconSize.XSmall
			}
		},
		[InputSize.Small] = {
			container = {
				tag = {
					["gap-small size-full-800 padding-medium radius-medium"] = Flags.FoundationDropdownSizeGap,
					["gap-xxsmall size-full-800 padding-medium radius-medium"] = not Flags.FoundationDropdownSizeGap
				}
			},
			text = {
				tag = "text-body-small"
			},
			arrow = {
				size = IconSize.Small
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = {
					["gap-small size-full-1000 padding-medium radius-medium"] = Flags.FoundationDropdownSizeGap,
					["size-full-1000 padding-medium radius-medium"] = not Flags.FoundationDropdownSizeGap
				}
			},
			text = {
				tag = "text-body-medium"
			},
			arrow = {
				size = IconSize.Medium
			}
		},
		[InputSize.Large] = {
			container = {
				tag = {
					["gap-small size-full-1200 padding-medium radius-medium"] = Flags.FoundationDropdownSizeGap,
					["size-full-1200 padding-medium radius-medium"] = not Flags.FoundationDropdownSizeGap
				}
			},
			text = {
				tag = "text-body-large"
			},
			arrow = {
				size = IconSize.Large
			}
		}
	}
	local t3 = {
		[ControlState.Disabled] = {
			container = if not Flags.FoundationDropdownVariant then {
				tag = "stroke-muted"
			} else nil,
			text = {
				tag = "content-muted"
			}
		},
		[ControlState.Initialize] = {
			container = if not Flags.FoundationDropdownVariant then {
				tag = "stroke-default"
			} else nil,
			text = {
				tag = "content-default"
			}
		},
		[ControlState.Default] = if not Flags.FoundationDropdownVariant then {
			container = {
				tag = "stroke-default"
			},
			text = {
				tag = "content-default"
			}
		} else nil,
		[ControlState.Hover] = if not Flags.FoundationDropdownVariant then {
			container = {
				tag = "stroke-emphasis"
			},
			text = {
				tag = "content-emphasis"
			}
		} else nil,
		[ControlState.Pressed] = if not Flags.FoundationDropdownVariant then {
			container = {
				tag = "stroke-emphasis"
			},
			text = {
				tag = "content-emphasis"
			}
		} else nil,
		Error = if Flags.FoundationDropdownVariant then {
			container = {
				tag = "stroke-alert"
			},
			text = {
				tag = "content-default"
			}
		} else nil
	}
	local v16 = Dash.map(t3, function(p1) -- line: 147
		-- upvalues: Dash (copy)
		return Dash.join(p1, {
			text = {
				tag = "content-muted"
			}
		})
	end)

	return {
		common = t1,
		sizes = t2,
		states = t3,
		placeholderStates = v16
	}
end

return function(p2, p3, p4, p5, b1: boolean, b2: boolean, b3: boolean, b4: boolean) -- line: 161
	-- upvalues: VariantsContext (copy), variantsFactory (copy), Flags (copy), getInputVariantsFactory (copy), InputVariant (copy), composeStyleVariant (copy)
	local v25 = VariantsContext.useVariants("Dropdown", variantsFactory, p2)
	local v26 = if not Flags.FoundationDropdownVariant then nil else VariantsContext.useVariants("InputField", getInputVariantsFactory, p2)
	local v27 = if not Flags.FoundationDropdownVariant then nil else v26.variants[p4 or InputVariant.Standard]
	local v28 = if Flags.FoundationDropdownVariant or not b2 then p5 else "Error"

	return composeStyleVariant(if not Flags.FoundationDropdownVariant then {} else v26.common, v25.common, if not Flags.FoundationDropdownVariant then {} else v26.sizes[p3], v25.sizes[p3], if not Flags.FoundationDropdownVariant or p4 == InputVariant.Utility then {} else v27, if not Flags.FoundationDropdownVariant then {} else v26.hoverState[b4], if not Flags.FoundationDropdownVariant then {} else v26.focusedState[b3], if not Flags.FoundationDropdownVariant then {} else v26.errorState[b2], if not b1 then v25.states[v28] else v25.placeholderStates[v28], if not Flags.FoundationDropdownVariant or p4 ~= InputVariant.Utility then {} else v27)
end
