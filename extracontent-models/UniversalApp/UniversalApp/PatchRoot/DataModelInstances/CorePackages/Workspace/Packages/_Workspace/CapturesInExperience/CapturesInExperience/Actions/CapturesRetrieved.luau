local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.Types)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 13
	return {
		captures = p1,
		selectedCapture = p2
	}
end)
