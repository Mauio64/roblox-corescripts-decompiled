local ParentParent = script.Parent.Parent
local OpenResultModal = require(ParentParent.Actions.OpenResultModal)

return function(p1) -- line: 11
	-- upvalues: OpenResultModal (copy)
	return function(p2) -- line: 12
		-- upvalues: OpenResultModal (copy), p1 (copy)
		p2:dispatch(OpenResultModal(p1))
	end
end
