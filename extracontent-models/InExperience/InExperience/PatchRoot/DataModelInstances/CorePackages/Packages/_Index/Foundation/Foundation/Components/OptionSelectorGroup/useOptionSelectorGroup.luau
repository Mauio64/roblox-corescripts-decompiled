local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.Orientation)

local OptionSelectorGroupContext = require(script.Parent.OptionSelectorGroupContext)

return function()
	return React.useContext(OptionSelectorGroupContext)
end
