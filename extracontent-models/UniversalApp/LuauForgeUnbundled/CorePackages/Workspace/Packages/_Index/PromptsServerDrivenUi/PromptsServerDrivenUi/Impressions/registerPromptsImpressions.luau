local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiCoreSystem")
local sduiImpressionEventType = SduiCoreSystem.SduiImpressionEventType
local getSduiImpressionHandlerRegistry = SduiCoreSystem.getSduiImpressionHandlerRegistry

local function registerPromptsImpressions()
	local v5 = {
		[sduiImpressionEventType.promptImpressions] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Impressions/SduiPromptImpressionsHandler")
			end,
			skipItemImpressionsLog = false
		}
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(v5)
end

return registerPromptsImpressions
