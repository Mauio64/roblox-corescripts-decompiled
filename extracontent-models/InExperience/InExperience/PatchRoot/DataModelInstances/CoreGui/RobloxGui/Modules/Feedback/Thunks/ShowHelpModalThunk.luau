local ParentParent = script.Parent.Parent
local ShowHelpModal = require(ParentParent.Actions.ShowHelpModal)

return function(p1) -- line: 7
	-- upvalues: ShowHelpModal (copy)
	return function(p2) -- line: 8
		-- upvalues: ShowHelpModal (copy), p1 (copy)
		p2:dispatch(ShowHelpModal(p1))
	end
end
