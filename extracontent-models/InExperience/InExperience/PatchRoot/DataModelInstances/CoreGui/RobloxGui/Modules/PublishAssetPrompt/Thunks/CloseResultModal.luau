local parent = script.Parent.Parent
local CloseResultModal = require(parent.Actions.CloseResultModal)

return function(object)
	object:dispatch(CloseResultModal())
end
