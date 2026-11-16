local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local TelemetryService = game:GetService("TelemetryService")

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors

local defineFastInt = game:DefineFastInt("SduiQueryImpressionsThrottlingHundredthsPercent", 10000)

local function SduiQueryImpressionsHandler(p, list, list2, data, _: number?)
	if not data then
		p.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.FailedToLogQueryImpressions,
			{ name = "SduiQueryImpressionsHandler", message = "Missing collectionAnalyticsData" },
			p.appPage
		)
		return
	end

	if #list == 0 or #list2 == 0 then
		return
	end

	local v = {}
	local queryTexts = {}

	for _, item in list do
		local item2 = list2[item]

		if item2 then
			table.insert(v, item)
			table.insert(queryTexts, item2.queryText or "")
		else
			p.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.FailedToLogQueryImpressions,
				{
					name = "SduiQueryImpressionsHandler",
					message = `Missing itemData at index {item}`
				},
				p.appPage
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
		eventContext = p.appPage,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = {
			absPositions = table.concat(v, ","),
			queryTexts = table.concat(queryTexts, ","),
			sortPos = data.collectionPosition,
			sortId = tostring(data.collectionId),
			componentType = data.collectionComponentType or "Pill"
		}
	})
end

return SduiQueryImpressionsHandler
