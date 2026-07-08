local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local StyleContext = require(scriptParent.StyleContext)
local React = require(ParentParent.React)

local function useTextSizeOffset() -- line: 13
	-- upvalues: React (copy), StyleContext (copy)
	return React.useContext(StyleContext).derivedValues.textSizeOffset
end

return useTextSizeOffset
