local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Providers.Style.Tokens)

local function getKnobSize(p, p2)
	local v = ({
		[InputSize.XSmall] = p.Size.Size_300,
		[InputSize.Small] = p.Size.Size_400,
		[InputSize.Medium] = p.Size.Size_500,
		[InputSize.Large] = p.Size.Size_600
	})[p2]
	return UDim2.fromOffset(v, v)
end

return getKnobSize
