local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local TelemetryService = game:GetService("TelemetryService")
local SduiErrors = require(Parent.SduiCoreSystem).SduiErrors
local v4 = game:DefineFastInt("SduiQueryImpressionsThrottlingHundredthsPercent", 10000)

local function SduiQueryImpressionsHandler(p1, t1: {[any]: any}, t2: {[any]: any}, p2, _: number?) -- line: 26
	-- upvalues: SduiErrors (copy), v4 (copy), TelemetryService (copy)
	if not p2 then
		p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogQueryImpressions, {
			name = "SduiQueryImpressionsHandler",
			message = "Missing collectionAnalyticsData"
		}, p1.appPage)

		return
	end

	if #t1 == 0 or #t2 == 0 then
		return
	end

	local t3 = {}
	local t4 = {}

	for _, v14 in t1 do
		local v15 = t2[v14]

		if v15 then
			table.insert(t3, v14)
			table.insert(t4, v15.queryText or "")
		else
			p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogQueryImpressions, {
				name = "SduiQueryImpressionsHandler",
				message = `Missing itemData at index { v14 }`
			}, p1.appPage)
		end
	end

	if #t4 == 0 then
		return
	end

	local t5 = {
		eventName = "queryImpressions",
		description = "Fired when query suggestion items are visible in an SDUI collection",
		backends = { "EventIngest" },
		throttlingPercentage = v4,
		lastUpdated = {
			26,
			6,
			24
		}
	}

	TelemetryService:LogEvent(t5, {
		eventContext = p1.appPage,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = {
			absPositions = table.concat(t3, ","),
			queryTexts = table.concat(t4, ","),
			sortPos = p2.collectionPosition,
			sortId = tostring(p2.collectionId),
			componentType = p2.collectionComponentType or "Pill"
		}
	})
end

return SduiQueryImpressionsHandler
