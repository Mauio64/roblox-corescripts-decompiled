local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.Enums.CapturesToastType)
require(ParentParent.Types)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 16
	return {
		toastType = p1,
		toastConfig = p2
	}
end)
