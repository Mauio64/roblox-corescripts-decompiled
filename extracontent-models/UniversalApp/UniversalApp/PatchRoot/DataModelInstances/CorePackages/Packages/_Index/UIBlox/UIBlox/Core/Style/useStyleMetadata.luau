local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent

local StyleContext = require(parent.StyleContext)
local React = require(parent2.React)

local function useStyleMetadata()
	local v = React.useContext(StyleContext)

	return if v then v.styleMetadata else nil
end

return useStyleMetadata
