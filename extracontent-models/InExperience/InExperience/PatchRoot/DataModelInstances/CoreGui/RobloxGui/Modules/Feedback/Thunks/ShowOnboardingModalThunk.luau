local ParentParent = script.Parent.Parent
local ShowOnboardingModal = require(ParentParent.Actions.ShowOnboardingModal)

return function(p1) -- line: 7
	-- upvalues: ShowOnboardingModal (copy)
	return function(p2) -- line: 8
		-- upvalues: ShowOnboardingModal (copy), p1 (copy)
		p2:dispatch(ShowOnboardingModal(p1))
	end
end
