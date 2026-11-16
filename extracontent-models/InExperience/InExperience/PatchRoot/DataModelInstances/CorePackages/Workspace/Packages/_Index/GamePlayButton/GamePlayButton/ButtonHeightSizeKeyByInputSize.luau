local parent = script:FindFirstAncestor("GamePlayButton").Parent

local Foundation = require(parent.Foundation)
local InputSize = Foundation.Enums.InputSize

return {
	[InputSize.XSmall] = "Size_600",
	[InputSize.Small] = "Size_800",
	[InputSize.Medium] = "Size_1000",
	[InputSize.Large] = "Size_1200"
}
