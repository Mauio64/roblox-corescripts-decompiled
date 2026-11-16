local parent = script:FindFirstAncestor("PromptsServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local ServerTriggeredModalImpressions = require(parent.ServerTriggeredModalImpressions)
local postPromptImpression = ServerTriggeredModalImpressions.postPromptImpression
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent

local v = {}

local function SduiPromptImpressionsHandler(p, list, list2, _, _: number?)
	list2 = list2 or v

	if #list == 0 or #list2 == 0 then
		p.dependencies.logger.reportError(SduiErrorType.FailedToLogPromptImpressions, {
			name = "SduiPromptImpressionsHandler",
			message = `No entries to log: impressionIndexes={#list}, itemAnalyticsDatas={#list2}`
		}, p.appPage)
		return
	end

	for _, item in list do
		local v2 = list2[item] or v

		if typeof(v2.promptType) == "string" then
			if typeof(v2.promptId) == "string" then
				postPromptImpression(p.dependencies.networking, v2.promptType, v2.promptId):catch(function()
					p.dependencies.logger.reportError(
						SduiErrorType.FailedToLogPromptImpressions,
						{
							name = "SduiPromptImpressionsHandler",
							message = `Failed to POST prompt impression for {v2.promptType}`
						},
						p.appPage
					)
				end)

				sendModalImpressionEvent(v2.promptId, v2.promptType)
			else
				p.dependencies.logger.reportError(
					SduiErrorType.FailedToLogPromptImpressions,
					{
						name = "SduiPromptImpressionsHandler",
						message = `Missing promptId at index {item}`
					},
					p.appPage
				)
			end
		else
			p.dependencies.logger.reportError(
				SduiErrorType.FailedToLogPromptImpressions,
				{
					name = "SduiPromptImpressionsHandler",
					message = `Missing promptType at index {item}`
				},
				p.appPage
			)
		end
	end
end

return SduiPromptImpressionsHandler
