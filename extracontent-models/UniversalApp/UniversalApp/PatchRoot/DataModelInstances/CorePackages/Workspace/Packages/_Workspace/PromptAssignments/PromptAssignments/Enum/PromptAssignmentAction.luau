local Parent = script:FindFirstAncestor("PromptAssignments").Parent
local addRawValueMethodToEnum = require(script.Parent.addRawValueMethodToEnum)
local enumerate = require(Parent.enumerate)
local t1 = {
	DismissPrompt = "DISMISS_PROMPT",
	DisablePrompt = "DISABLE_PROMPT"
}
local v5 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v5, t1)

return v5
