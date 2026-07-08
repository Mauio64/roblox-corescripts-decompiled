local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

require(scriptParentParent.CapturesCommon)
require(scriptParent.Enums.CaptureType)
require(scriptParent.Enums.PromptType)

return {}
