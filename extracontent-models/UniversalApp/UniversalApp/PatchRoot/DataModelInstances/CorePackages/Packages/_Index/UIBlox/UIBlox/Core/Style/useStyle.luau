local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParent.App.Style.StyleTypes)

local StyleContext = require(scriptParent.StyleContext)
local React = require(ParentParentParent.React)

local function useStyle() -- line: 15
	-- upvalues: React (copy), StyleContext (copy)
	return React.useContext(StyleContext).style
end

return useStyle
