local scriptParent = script.Parent
local Parent = script:FindFirstAncestor("Foundation").Parent
local TextSizeOffsetContext = require(scriptParent.TextSizeOffsetContext)
local React = require(Parent.React)

local function useTextSizeOffset() -- line: 8
	-- upvalues: React (copy), TextSizeOffsetContext (copy)
	return React.useContext(TextSizeOffsetContext)
end

return useTextSizeOffset
