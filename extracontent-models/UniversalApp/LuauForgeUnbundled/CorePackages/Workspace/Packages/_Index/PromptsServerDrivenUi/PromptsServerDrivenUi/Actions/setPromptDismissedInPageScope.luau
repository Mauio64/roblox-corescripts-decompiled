local getSduiClientPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiCoreSystem").getSduiClientPageScope

local function setPromptDismissedInPageScope(p2, p3)
	local sduiClientPageScope = getSduiClientPageScope(p2)
	local dismissedPromptTypes = sduiClientPageScope.get("dismissedPromptTypes")
	local v5 = typeof(dismissedPromptTypes) ~= "table" and {} or table.clone(dismissedPromptTypes)
	v5[p3] = true
	sduiClientPageScope.set("dismissedPromptTypes", v5)
end

return setPromptDismissedInPageScope
