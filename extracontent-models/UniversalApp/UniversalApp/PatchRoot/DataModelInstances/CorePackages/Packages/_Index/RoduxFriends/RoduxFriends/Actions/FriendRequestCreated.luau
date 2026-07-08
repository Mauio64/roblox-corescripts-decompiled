local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.roduxFriendsTypes)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 9
	return p1
end)
