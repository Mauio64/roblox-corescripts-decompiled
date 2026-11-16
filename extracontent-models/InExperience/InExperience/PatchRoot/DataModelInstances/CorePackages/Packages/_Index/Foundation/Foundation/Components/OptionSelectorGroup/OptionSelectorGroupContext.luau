local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.FillBehavior)

local OptionSelectorGroupSize = require(Foundation.Enums.OptionSelectorGroupSize)
local Orientation = require(Foundation.Enums.Orientation)

return React.createContext({
	value = nil,
	onValueChanged = function(_: string?)
		warn("No OptionSelectorGroupProvider found for OptionSelectorGroup")
	end,
	orientation = Orientation.Vertical,
	Selectable = true,
	testId = "",
	size = OptionSelectorGroupSize.Medium,
	fillBehavior = nil
})
