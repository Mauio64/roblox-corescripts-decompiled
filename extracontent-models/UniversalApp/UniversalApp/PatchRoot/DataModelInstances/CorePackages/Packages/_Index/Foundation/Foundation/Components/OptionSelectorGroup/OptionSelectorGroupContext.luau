local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Orientation = require(Foundation.Enums.Orientation)

return React.createContext({
	value = nil,
	Selectable = true,
	testId = "",
	onValueChanged = function(_: string?) -- line: 10
		warn("No OptionSelectorGroupProvider found for OptionSelectorGroup")
	end,
	orientation = Orientation.Vertical
})
