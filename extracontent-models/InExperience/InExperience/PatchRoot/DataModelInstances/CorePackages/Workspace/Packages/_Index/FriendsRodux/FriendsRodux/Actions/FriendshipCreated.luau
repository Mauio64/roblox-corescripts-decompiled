local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.roduxFriendsTypes)

return Rodux.makeActionCreator(script.Name, function(s1: string, s2: string) -- line: 8
	return {
		payload = {
			userId1 = s1,
			userId2 = s2
		}
	}
end)
