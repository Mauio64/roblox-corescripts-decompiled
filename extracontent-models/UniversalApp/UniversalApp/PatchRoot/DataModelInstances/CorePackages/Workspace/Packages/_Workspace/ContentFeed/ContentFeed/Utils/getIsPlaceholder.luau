local ParentParent = script.Parent.Parent
local PlaceholderType = require(ParentParent.Enums.PlaceholderType)

return function(s1: string) -- line: 5
	-- upvalues: PlaceholderType (copy)
	if PlaceholderType[s1] then
		return true
	end

	return false
end
