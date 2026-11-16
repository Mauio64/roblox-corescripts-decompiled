local parent = script.Parent
local parent2 = script:FindFirstAncestor("Foundation").Parent
local TextSizeOffsetContext = require(parent.TextSizeOffsetContext)

local React = require(parent2.React)

local function useTextSizeOffset()
	return React.useContext(TextSizeOffsetContext)
end

return useTextSizeOffset
