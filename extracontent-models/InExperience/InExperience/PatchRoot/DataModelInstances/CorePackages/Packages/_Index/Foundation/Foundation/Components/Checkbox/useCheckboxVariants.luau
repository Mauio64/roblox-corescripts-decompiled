local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Components.Types)
require(Foundation.Components.InternalInput)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ControlState)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 30
	-- upvalues: Flags (copy), InputSize (copy)
	local v8 = if not Flags.FoundationToggleVisualUpdate then {
		input = {
			tag = "radius-small",
			checkedStyle = p1.Color.ActionSubEmphasis.Background,
			cursorRadius = UDim.new(0, p1.Radius.Small)
		},
		checkmark = {
			tag = "position-center-center anchor-center-center content-action-sub-emphasis"
		}
	} else {
		input = {
			tag = "radius-small",
			colors = {
				checkedStyle = p1.Color.ActionSubEmphasis.Background
			},
			cursorRadius = UDim.new(0, p1.Radius.Small)
		},
		checkmark = {
			tag = "position-center-center anchor-center-center content-action-sub-emphasis"
		}
	}
	local t1 = {
		[InputSize.XSmall] = {
			input = {
				size = UDim2.fromOffset(p1.Size.Size_400, p1.Size.Size_400)
			},
			checkmark = {
				tag = "size-400"
			}
		},
		[InputSize.Small] = {
			input = {
				size = UDim2.fromOffset(p1.Size.Size_500, p1.Size.Size_500)
			},
			checkmark = {
				tag = "size-500"
			}
		},
		[InputSize.Medium] = {
			input = {
				size = UDim2.fromOffset(p1.Size.Size_600, p1.Size.Size_600)
			},
			checkmark = {
				tag = "size-600"
			}
		},
		[InputSize.Large] = {
			input = {
				size = UDim2.fromOffset(p1.Size.Size_700, p1.Size.Size_700)
			},
			checkmark = {
				tag = "size-700"
			}
		}
	}

	return {
		common = v8,
		sizes = t1
	}
end

return function(p2, p3) -- line: 73
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v12 = VariantsContext.useVariants("Checkbox", variantsFactory, p2)

	return composeStyleVariant(v12.common, v12.sizes[p3])
end
