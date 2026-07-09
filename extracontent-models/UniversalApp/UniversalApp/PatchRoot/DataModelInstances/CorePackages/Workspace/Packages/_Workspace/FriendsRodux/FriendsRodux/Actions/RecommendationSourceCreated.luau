local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.roduxFriendsTypes)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 8
	return {
		payload = t1
	}
end)
