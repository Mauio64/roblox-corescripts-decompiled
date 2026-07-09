local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.Enums.CaptureTriggerType)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 12
	return {
		triggerType = p1
	}
end)
