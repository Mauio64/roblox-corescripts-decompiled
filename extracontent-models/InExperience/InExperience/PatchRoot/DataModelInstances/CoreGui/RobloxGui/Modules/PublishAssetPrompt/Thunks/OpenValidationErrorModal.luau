local parent = script.Parent.Parent
local OpenValidationErrorModal = require(parent.Actions.OpenValidationErrorModal)

return function(object)
	object:dispatch(OpenValidationErrorModal())
end
