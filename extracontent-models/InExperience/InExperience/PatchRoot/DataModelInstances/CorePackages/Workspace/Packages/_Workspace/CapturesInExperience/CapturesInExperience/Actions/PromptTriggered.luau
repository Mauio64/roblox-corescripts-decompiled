local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.Enums.PromptType)
require(ParentParent.Types)

return Rodux.makeActionCreator(script.Name, function(p1, p2, p3) -- line: 15
	return {
		promptData = p3,
		promptId = p1,
		promptType = p2
	}
end)
