local ParentParent = script.Parent.Parent.Parent
local useStyle = require(ParentParent.UIBlox).Core.Style.useStyle

local function useNavBarSize() -- line: 8
	-- upvalues: useStyle (copy)
	return useStyle().Tokens.Size.Size_1600
end

return useNavBarSize
