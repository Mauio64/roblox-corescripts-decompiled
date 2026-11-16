local parent = script.Parent.Parent

require(parent.util.Types)
local getEditableInstanceFromContext = require(parent.util.getEditableInstanceFromContext)

return function(p, p2: string, p3)
	local editableInstanceFromContext, v = getEditableInstanceFromContext(p, p2, p3.editableMeshes, p3)

	if editableInstanceFromContext then
		return true, v
	end

	return false
end
