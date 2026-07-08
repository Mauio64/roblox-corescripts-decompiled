local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Components.Types)

local InputSize = require(Foundation.Enums.InputSize)
local InputVariant = require(Foundation.Enums.InputVariant)

require(Foundation.Enums.IconSize)

local Radius = require(Foundation.Enums.Radius)

require(Foundation.Utility.composeStyleVariant)
require(Foundation.Providers.Style.Tokens)

local function getInputVariantsFactory(p1) -- line: 40
	-- upvalues: Flags (copy), InputSize (copy), InputVariant (copy), Dash (copy), Radius (copy)
	local t1 = {
		container = {
			bgStyle = if not Flags.FoundationTextInputRemoveBackgroundStyle then p1.Color.Shift.Shift_100 else nil,
			strokeStyle = p1.Color.Stroke.Emphasis,
			strokeThickness = p1.Stroke.Standard
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			container = {
				tag = "size-full-600"
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "size-full-800"
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "size-full-1000"
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "size-full-1200"
			}
		}
	}
	local t3 = {
		[InputVariant.Standard] = if not Flags.FoundationTextInputRemoveBackgroundStyle then {
			container = {
				bgStyle = p1.Color.Shift.Shift_100
			}
		} else {},
		[InputVariant.Contrast] = {
			container = {
				bgStyle = p1.Color.Shift.Shift_200,
				strokeStyle = Dash.None
			}
		},
		[InputVariant.Utility] = {
			container = {
				bgStyle = Dash.None,
				strokeStyle = Dash.None
			}
		}
	}
	local t4 = {
		[true] = {
			container = {
				strokeStyle = p1.Color.System.Alert
			}
		},
		[false] = {}
	}
	local t5 = {
		[true] = {
			container = {
				strokeStyle = p1.Color.System.Emphasis,
				strokeThickness = p1.Stroke.Standard * 2
			}
		},
		[false] = {}
	}
	local t6 = {
		[true] = {
			container = {
				strokeThickness = p1.Stroke.Standard * 2
			}
		},
		[false] = {}
	}
	local t7 = {
		[InputSize.XSmall] = {
			container = {
				tag = {
					["radius-small"] = true
				}
			}
		},
		[InputSize.Small] = {
			container = {
				tag = {
					["radius-medium"] = true
				}
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = {
					["radius-medium"] = true
				}
			}
		},
		[InputSize.Large] = {
			container = {
				tag = {
					["radius-medium"] = true
				}
			}
		}
	}
	local t8 = {
		[Radius.None] = {
			container = {
				tag = {
					["radius-none"] = true
				}
			}
		},
		[Radius.XSmall] = {
			container = {
				tag = {
					["radius-xsmall"] = true
				}
			}
		},
		[Radius.Small] = {
			container = {
				tag = {
					["radius-small"] = true
				}
			}
		},
		[Radius.Medium] = {
			container = {
				tag = {
					["radius-medium"] = true
				}
			}
		},
		[Radius.Large] = {
			container = {
				tag = {
					["radius-large"] = true
				}
			}
		}
	}

	return {
		common = t1,
		sizes = t2,
		variants = t3,
		defaultRadius = t7,
		radius = t8,
		errorState = t4,
		focusedState = t5,
		hoverState = t6
	}
end

return getInputVariantsFactory
