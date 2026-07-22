local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.Types)

return Rodux.makeActionCreator(script.Name, function(p1, s1: string) -- line: 14
	return {
		capture = p1,
		sessionId = s1
	}
end)
