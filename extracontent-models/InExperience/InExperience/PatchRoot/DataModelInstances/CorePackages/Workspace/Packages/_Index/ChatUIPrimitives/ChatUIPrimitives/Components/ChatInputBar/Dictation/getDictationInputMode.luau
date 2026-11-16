local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local Constants = require(parent.DictationCore.Constants)

local DictationInputMode = Constants.DictationInputMode

local function getDictationInputMode(flag: boolean?)
	return if flag then DictationInputMode.Hybrid else nil
end

return getDictationInputMode
