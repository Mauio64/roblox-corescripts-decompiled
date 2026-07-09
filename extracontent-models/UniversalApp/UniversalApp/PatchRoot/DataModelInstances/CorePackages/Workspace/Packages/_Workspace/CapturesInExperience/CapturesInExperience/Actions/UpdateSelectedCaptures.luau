local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.Types)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 12
	return {
		selectedCaptures = t1
	}
end)
