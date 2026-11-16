local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent

local StyleContext = require(parent.StyleContext)
local React = require(parent2.React)

local function useTextSizeOffset()
	return React.useContext(StyleContext).derivedValues.textSizeOffset
end

return useTextSizeOffset
