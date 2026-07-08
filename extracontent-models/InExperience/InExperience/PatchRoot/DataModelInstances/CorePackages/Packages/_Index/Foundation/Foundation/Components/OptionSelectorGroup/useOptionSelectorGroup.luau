local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.Orientation)

local OptionSelectorGroupContext = require(script.Parent.OptionSelectorGroupContext)

return function() -- line: 11
	-- upvalues: React (copy), OptionSelectorGroupContext (copy)
	return React.useContext(OptionSelectorGroupContext)
end
