local parent = script.Parent.Parent
local ShowOnboardingModal = require(parent.Actions.ShowOnboardingModal)

return function(p)
	return function(object)
		object:dispatch(ShowOnboardingModal(p))
	end
end
