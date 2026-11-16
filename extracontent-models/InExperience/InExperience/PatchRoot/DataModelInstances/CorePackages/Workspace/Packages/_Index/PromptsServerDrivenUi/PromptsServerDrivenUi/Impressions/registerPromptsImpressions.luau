local PromptsServerDrivenUi = script:FindFirstAncestor("PromptsServerDrivenUi")
local parent = PromptsServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiImpressionEventType = SduiCoreSystem.SduiImpressionEventType
local getSduiImpressionHandlerRegistry = SduiCoreSystem.getSduiImpressionHandlerRegistry

local function registerPromptsImpressions()
	local v = {
		[SduiImpressionEventType.promptImpressions] = {
			lazyHandler = function()
				return require(PromptsServerDrivenUi.Impressions.SduiPromptImpressionsHandler)
			end,
			skipItemImpressionsLog = false
		}
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(v)
end

return registerPromptsImpressions
