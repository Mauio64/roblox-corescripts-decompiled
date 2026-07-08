local Foundation = script:FindFirstAncestor("Foundation")
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Providers.Style.Tokens)

local Flags = require(Foundation.Utility.Flags)

local function getKnobSize(p1, p2) -- line: 10
	-- upvalues: Flags (copy), InputSize (copy)
	local v7 = ((if not Flags.FoundationToggleVisualUpdate then {
		[InputSize.XSmall] = p1.Size.Size_200,
		[InputSize.Small] = p1.Size.Size_300,
		[InputSize.Medium] = p1.Size.Size_400,
		[InputSize.Large] = p1.Size.Size_700
	} else {
		[InputSize.XSmall] = p1.Size.Size_300,
		[InputSize.Small] = p1.Size.Size_400,
		[InputSize.Medium] = p1.Size.Size_500,
		[InputSize.Large] = p1.Size.Size_600
	}))[p2]

	return UDim2.fromOffset(v7, v7)
end

return getKnobSize
