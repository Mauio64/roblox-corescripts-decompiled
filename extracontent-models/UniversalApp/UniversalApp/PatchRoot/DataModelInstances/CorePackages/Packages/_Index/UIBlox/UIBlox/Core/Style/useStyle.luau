local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

require(parent2.App.Style.StyleTypes)
local StyleContext = require(parent.StyleContext)
local React = require(parent3.React)

local function useStyle()
	return React.useContext(StyleContext).style
end

return useStyle
