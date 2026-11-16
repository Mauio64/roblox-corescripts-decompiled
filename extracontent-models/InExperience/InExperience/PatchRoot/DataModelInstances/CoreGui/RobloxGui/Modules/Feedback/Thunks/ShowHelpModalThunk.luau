local parent = script.Parent.Parent
local ShowHelpModal = require(parent.Actions.ShowHelpModal)

return function(p)
	return function(object)
		object:dispatch(ShowHelpModal(p))
	end
end
