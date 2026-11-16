local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

require(parent.Enums.PromptType)
require(parent.Types)

return Rodux.makeActionCreator(script.Name, function(promptId, promptType, promptData)
	return { promptData = promptData, promptId = promptId, promptType = promptType }
end)
