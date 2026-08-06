local TelemetryService = game:GetService("TelemetryService")
local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local SduiErrors = require(Parent.SduiCoreSystem).SduiErrors
local v5 = game:DefineFastInt("SduiPlayerTileImpressionsThrottlingHundredthsPercent", 10000)

local function SduiPlayerTileImpressionsHandler(p1, t1: {[any]: any}, t2: {[any]: any}, p2, n1: number?) -- line: 18
	-- upvalues: SduiErrors (copy), TelemetryService (copy), v5 (copy), LocalizationService (copy)
	if not p2 then
		p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogPlayerTileImpressions, {
			name = "SduiPlayerTileImpressionsHandler",
			message = "Missing collectionAnalyticsData"
		}, p1.appPage)

		return
	end

	if #t1 == 0 or #t2 == 0 then
		return
	end

	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local itemsPerRow = p2.itemsPerRow

	for _, v18 in t1 do
		local v19 = t2[v18]
		local v20 = if not v19 then nil else v19.playerId

		if v20 ~= nil then
			table.insert(t3, v18)
			table.insert(t4, v20)
			table.insert(t5, v19.playerName or (v19.name or (v19.username or "")))

			if typeof(n1) == "number" and typeof(itemsPerRow) == "number" and itemsPerRow > 0 then
				table.insert(t6, n1 + math.ceil(v18 / itemsPerRow) - 1)
			end
		end
	end

	if #t4 == 0 then
		return
	end

	local userSearchSessionId = p2.userSearchSessionId

	TelemetryService:LogEvent({
		eventName = "playerTileImpressions",
		description = "Fired when player tiles are visible in an SDUI collection",
		backends = { "EventIngest" },
		throttlingPercentage = v5,
		lastUpdated = {
			26,
			7,
			17
		}
	}, {
		eventContext = p2.eventContext or "playerSearch",
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = {
			tilePos = table.concat(t3, ","),
			playerId = table.concat(t4, ","),
			playerName = table.concat(t5, ","),
			userSearchSessionId = if userSearchSessionId == nil then nil else tostring(userSearchSessionId),
			sortId = if p2.collectionId == nil then nil else tostring(p2.collectionId),
			sortPosition = p2.collectionPosition,
			pageContext = p2.pageContext or p1.appPage,
			rowInSort = if not (#t6 > 0) then nil else table.concat(t6, ","),
			locale = LocalizationService.RobloxLocaleId
		}
	})
end

return SduiPlayerTileImpressionsHandler
