local ParentParent = script.Parent.Parent
local CloseResultModal = require(ParentParent.Actions.CloseResultModal)

return function(p1) -- line: 4
	-- upvalues: CloseResultModal (copy)
	p1:dispatch(CloseResultModal())
end
