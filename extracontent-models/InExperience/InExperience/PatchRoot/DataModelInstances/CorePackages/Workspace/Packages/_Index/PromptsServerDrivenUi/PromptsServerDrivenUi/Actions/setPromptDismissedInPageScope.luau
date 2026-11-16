local parent = script:FindFirstAncestor("PromptsServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local function setPromptDismissedInPageScope(p: string, p2: string)
	local sduiClientPageScope = getSduiClientPageScope(p)
	local dismissedPromptTypes = sduiClientPageScope.get("dismissedPromptTypes")
	local v = typeof(dismissedPromptTypes) ~= "table" and {} or table.clone(dismissedPromptTypes)
	v[p2] = true
	sduiClientPageScope.set("dismissedPromptTypes", v)
end

return setPromptDismissedInPageScope
