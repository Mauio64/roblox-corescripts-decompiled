local module = require("@luauforge/bundled/frO")

local v5 = { DismissPrompt = "DISMISS_PROMPT", DisablePrompt = "DISABLE_PROMPT" }
local v6 = require("@luauforge/bundled/frP")("PromptAssignmentAction", v5)

module(v6, v5)

return v6
