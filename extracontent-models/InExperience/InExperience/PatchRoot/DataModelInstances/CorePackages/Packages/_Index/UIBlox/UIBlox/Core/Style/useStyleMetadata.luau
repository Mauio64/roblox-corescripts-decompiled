local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local StyleContext = require(scriptParent.StyleContext)
local React = require(ParentParent.React)

local function useStyleMetadata() -- line: 13
	-- upvalues: React (copy), StyleContext (copy)
	local v6 = React.useContext(StyleContext)

	if not v6 then
		return nil
	end

	return v6.styleMetadata
end

return useStyleMetadata
