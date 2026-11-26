local TelemetryService = game:GetService("TelemetryService")

local sduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").SduiErrors

local defineFastInt = game:DefineFastInt("SduiQueryImpressionsThrottlingHundredthsPercent", 10000)

local function SduiQueryImpressionsHandler(p2, list, list2, data, p3)
	if not data then
		p2.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.FailedToLogQueryImpressions,
			{
				name = "SduiQueryImpressionsHandler",
				message = "Missing collectionAnalyticsData"
			},
			p2.appPage
		)
		return
	end

	if #list == 0 or #list2 == 0 then
		return
	end

	local v5 = {}
	local queryTexts = {}

	for k, item in list do
		local item2 = list2[item]

		if item2 then
			table.insert(v5, item)
			table.insert(queryTexts, item2.queryText or "")
		else
			p2.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.FailedToLogQueryImpressions,
				{
					name = "SduiQueryImpressionsHandler",
					message = `Missing itemData at index {item}`
				},
				p2.appPage
			)
		end
	end

	if #queryTexts == 0 then
		return
	end

	TelemetryService:LogEvent({
		eventName = "queryImpressions",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 6, 24 },
		description = "Fired when query suggestion items are visible in an SDUI collection"
	}, {
		eventContext = p2.appPage,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = {
			absPositions = table.concat(v5, ","),
			queryTexts = table.concat(queryTexts, ","),
			sortPos = data.collectionPosition,
			sortId = tostring(data.collectionId),
			componentType = data.collectionComponentType or "Pill"
		}
	})
end

return SduiQueryImpressionsHandler
