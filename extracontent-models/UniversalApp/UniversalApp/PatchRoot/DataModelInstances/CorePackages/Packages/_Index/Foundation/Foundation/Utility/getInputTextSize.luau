local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

local InputLabelSize = require(Foundation.Enums.InputLabelSize)

local v = {
	[InputSize.Large] = InputLabelSize.Large,
	[InputSize.Medium] = InputLabelSize.Medium,
	[InputSize.Small] = InputLabelSize.Small,
	[InputSize.XSmall] = InputLabelSize.XSmall
}

local function getInputTextSize(p)
	return v[p]
end

return getInputTextSize
