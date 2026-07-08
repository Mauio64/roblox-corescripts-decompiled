local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local getEditableInstanceFromContext = require(ParentParent.util.getEditableInstanceFromContext)

return function(p1, s1: string, p2) -- line: 6
	-- upvalues: getEditableInstanceFromContext (copy)
	local v6, v7 = getEditableInstanceFromContext(p1, s1, p2.editableImages, p2)

	if not v6 then
		return false
	end

	return true, v7
end
