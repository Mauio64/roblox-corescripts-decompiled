local sduiErrorType = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiCoreSystem").SduiErrors.SduiErrorType

local ServerTriggeredModalImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/ServerTriggeredModalImpressions")
local postPromptImpression = ServerTriggeredModalImpressions.postPromptImpression
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent

local v5 = {}

local function SduiPromptImpressionsHandler(p2, list, p3, p4, p5)
	local v6 = p3 or v5

	if #list == 0 or #v6 == 0 then
		p2.dependencies.logger.reportError(sduiErrorType.FailedToLogPromptImpressions, {
			name = "SduiPromptImpressionsHandler",
			message = `No entries to log: impressionIndexes={#list}, itemAnalyticsDatas={#v6}`
		}, p2.appPage)
		return
	end

	for k, item in list do
		local v7 = v6[item] or v5

		if typeof(v7.promptType) == "string" then
			if typeof(v7.promptId) == "string" then
				postPromptImpression(p2.dependencies.networking, v7.promptType, v7.promptId):catch(function()
					p2.dependencies.logger.reportError(
						sduiErrorType.FailedToLogPromptImpressions,
						{
							name = "SduiPromptImpressionsHandler",
							message = `Failed to POST prompt impression for {v7.promptType}`
						},
						p2.appPage
					)
				end)

				sendModalImpressionEvent(v7.promptId, v7.promptType)
			else
				p2.dependencies.logger.reportError(
					sduiErrorType.FailedToLogPromptImpressions,
					{
						name = "SduiPromptImpressionsHandler",
						message = `Missing promptId at index {item}`
					},
					p2.appPage
				)
			end
		else
			p2.dependencies.logger.reportError(
				sduiErrorType.FailedToLogPromptImpressions,
				{
					name = "SduiPromptImpressionsHandler",
					message = `Missing promptType at index {item}`
				},
				p2.appPage
			)
		end
	end
end

return SduiPromptImpressionsHandler
