local TelemetryService = game:GetService("TelemetryService")
local LocalizationService = game:GetService("LocalizationService")

local sduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem").SduiErrors

local defineFastInt = game:DefineFastInt("SduiPlayerTileImpressionsThrottlingHundredthsPercent", 10000)

local function SduiPlayerTileImpressionsHandler(p2, list, list2, data, value)
	if not data then
		p2.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.FailedToLogPlayerTileImpressions,
			{
				name = "SduiPlayerTileImpressionsHandler",
				message = "Missing collectionAnalyticsData"
			},
			p2.appPage
		)
		return
	end

	if #list == 0 or #list2 == 0 then
		return
	end

	local itemsPerRow = data.itemsPerRow
	local v5 = {}
	local playerIds = {}
	local playerNames = {}
	local v6 = {}

	for k, item in list do
		local item2 = list2[item]
		local playerId = if item2 then item2.playerId else nil

		if playerId == nil then
			continue
		end

		table.insert(v5, item)
		table.insert(playerIds, playerId)
		table.insert(playerNames, item2.playerName or item2.name or item2.username or "")

		if not (typeof(value) == "number" and typeof(itemsPerRow) == "number" and itemsPerRow > 0) then
			continue
		end

		table.insert(v6, value + math.ceil(item / itemsPerRow) - 1)
	end

	if #playerIds == 0 then
		return
	end

	local userSearchSessionId = data.userSearchSessionId

	local v9 = {
		eventContext = data.eventContext or "playerSearch",
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = 0
	}

	local v10 = {
		tilePos = table.concat(v5, ","),
		playerId = table.concat(playerIds, ","),
		playerName = table.concat(playerNames, ","),
		userSearchSessionId = 0,
		sortId = 0,
		sortPosition = 0,
		pageContext = 0,
		rowInSort = 0,
		locale = 0
	}
	local v11 = if userSearchSessionId ~= nil then tostring(userSearchSessionId) else nil
	v10.userSearchSessionId = v11
	local v12 = if data.collectionId ~= nil then tostring(data.collectionId) else nil
	v10.sortId = v12

	v10.sortPosition = data.collectionPosition
	v10.pageContext = data.pageContext or p2.appPage
	local v13 = if #v6 > 0 then table.concat(v6, ",") else nil
	v10.rowInSort = v13
	v10.locale = LocalizationService.RobloxLocaleId
	v9.customFields = v10
	TelemetryService:LogEvent({
		eventName = "playerTileImpressions",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 7, 17 },
		description = "Fired when player tiles are visible in an SDUI collection"
	}, v9)
end

return SduiPlayerTileImpressionsHandler
