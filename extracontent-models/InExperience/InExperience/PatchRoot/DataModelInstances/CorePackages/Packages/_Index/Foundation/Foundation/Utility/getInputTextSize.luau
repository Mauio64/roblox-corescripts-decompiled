local Foundation = script:FindFirstAncestor("Foundation")
local InputSize = require(Foundation.Enums.InputSize)
local InputLabelSize = require(Foundation.Enums.InputLabelSize)
local t1 = {
	[InputSize.Large] = InputLabelSize.Large,
	[InputSize.Medium] = InputLabelSize.Medium,
	[InputSize.Small] = InputLabelSize.Small,
	[InputSize.XSmall] = InputLabelSize.Small
}

local function getInputTextSize(p1) -- line: 19
	-- upvalues: t1 (copy)
	return t1[p1]
end

return getInputTextSize
