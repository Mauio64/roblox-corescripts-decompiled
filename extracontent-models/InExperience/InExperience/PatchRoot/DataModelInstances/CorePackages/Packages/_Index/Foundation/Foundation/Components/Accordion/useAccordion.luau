local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.InputSize)
require(Foundation.Components.Types)

local AccordionContext = require(script.Parent.AccordionContext)

return function() -- line: 22
	-- upvalues: React (copy), AccordionContext (copy)
	return React.useContext(AccordionContext)
end
