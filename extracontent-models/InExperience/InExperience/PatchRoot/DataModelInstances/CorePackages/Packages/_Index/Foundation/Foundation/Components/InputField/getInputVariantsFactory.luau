local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)

require(Foundation.Components.Types)

local InputSize = require(Foundation.Enums.InputSize)

local InputVariant = require(Foundation.Enums.InputVariant)

require(Foundation.Enums.IconSize)

local Radius = require(Foundation.Enums.Radius)

require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local Flags = require(Foundation.Utility.Flags)

local function getInputVariantsFactory(p)
	local fgStyle

	if Flags.FoundationFixColorOnScrubbableNumberInput then
		fgStyle = p.Color.Shift.Shift_200
	end

	local container = {
		fgStyle = fgStyle,
		strokeStyle = p.Color.Stroke.Emphasis,
		strokeThickness = p.Stroke.Standard
	}

	local sizes = {
		[InputSize.XSmall] = {
			container = { tag = "size-full-600" }
		},
		[InputSize.Small] = {
			container = { tag = "size-full-800" }
		},
		[InputSize.Medium] = {
			container = { tag = "size-full-1000" }
		},
		[InputSize.Large] = {
			container = { tag = "size-full-1200" }
		}
	}

	local variants = { [InputVariant.Standard] = {} }
	local contrast = InputVariant.Contrast
	local fgStyle2

	if Flags.FoundationFixColorOnScrubbableNumberInput then
		fgStyle2 = p.Color.Shift.Shift_300
	end

	variants[contrast] = {
		container = {
			fgStyle = fgStyle2,
			bgStyle = p.Color.Shift.Shift_200,
			strokeStyle = Dash.None
		}
	}

	variants[InputVariant.Utility] = {
		container = { fgStyle = Dash.None, bgStyle = Dash.None, strokeStyle = Dash.None }
	}

	local errorState = {
		[true] = {
			container = { strokeStyle = p.Color.System.Alert }
		},
		[false] = {}
	}

	local focusedState = {
		[true] = {
			container = {
				strokeStyle = p.Color.System.Emphasis,
				strokeThickness = p.Stroke.Standard * 2
			}
		},
		[false] = {}
	}

	local hoverState = {
		[true] = {
			container = {
				strokeThickness = p.Stroke.Standard * 2
			}
		},
		[false] = {}
	}
	return {
		common = { container = container },
		sizes = sizes,
		variants = variants,
		defaultRadius = {
			[InputSize.XSmall] = {
				container = {
					tag = { ["radius-small"] = true }
				}
			},
			[InputSize.Small] = {
				container = {
					tag = { ["radius-medium"] = true }
				}
			},
			[InputSize.Medium] = {
				container = {
					tag = { ["radius-medium"] = true }
				}
			},
			[InputSize.Large] = {
				container = {
					tag = { ["radius-medium"] = true }
				}
			}
		},
		radius = {
			[Radius.None] = {
				container = {
					tag = { ["radius-none"] = true }
				}
			},
			[Radius.XSmall] = {
				container = {
					tag = { ["radius-xsmall"] = true }
				}
			},
			[Radius.Small] = {
				container = {
					tag = { ["radius-small"] = true }
				}
			},
			[Radius.Medium] = {
				container = {
					tag = { ["radius-medium"] = true }
				}
			},
			[Radius.Large] = {
				container = {
					tag = { ["radius-large"] = true }
				}
			}
		},
		errorState = errorState,
		focusedState = focusedState,
		hoverState = hoverState
	}
end

return getInputVariantsFactory
