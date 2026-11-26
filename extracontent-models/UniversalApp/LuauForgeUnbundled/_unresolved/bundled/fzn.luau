local module = require("@luauforge/bundled/fzi")

local v5 = { DismissPrompt = "DISMISS_PROMPT", DisablePrompt = "DISABLE_PROMPT" }
local v6 = require("@luauforge/bundled/fzj")("PromptAssignmentAction", v5)

module(v6, v5)

return v6
