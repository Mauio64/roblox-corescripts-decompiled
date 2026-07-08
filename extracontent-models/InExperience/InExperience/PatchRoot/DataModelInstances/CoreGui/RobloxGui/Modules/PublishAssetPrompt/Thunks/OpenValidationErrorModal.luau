local ParentParent = script.Parent.Parent
local OpenValidationErrorModal = require(ParentParent.Actions.OpenValidationErrorModal)

return function(p1) -- line: 5
	-- upvalues: OpenValidationErrorModal (copy)
	p1:dispatch(OpenValidationErrorModal())
end
