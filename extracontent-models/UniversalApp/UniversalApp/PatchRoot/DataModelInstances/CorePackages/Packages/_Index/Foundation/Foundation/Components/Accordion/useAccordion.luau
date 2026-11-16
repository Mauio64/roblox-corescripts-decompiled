local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.InputPlacement)
require(Foundation.Enums.InputSize)
require(Foundation.Components.Types)

local AccordionContext = require(script.Parent.AccordionContext)

return function()
	return React.useContext(AccordionContext)
end
