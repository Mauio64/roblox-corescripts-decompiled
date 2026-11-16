local parent = script.Parent.Parent
local OpenResultModal = require(parent.Actions.OpenResultModal)

return function(p)
	return function(object)
		object:dispatch(OpenResultModal(p))
	end
end
