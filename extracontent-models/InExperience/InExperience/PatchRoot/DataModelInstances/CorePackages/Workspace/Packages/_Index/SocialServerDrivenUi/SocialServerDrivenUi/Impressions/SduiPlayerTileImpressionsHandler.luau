local TelemetryService = game:GetService("TelemetryService")
local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors

local defineFastInt = game:DefineFastInt("SduiPlayerTileImpressionsThrottlingHundredthsPercent", 10000)

local function SduiPlayerTileImpressionsHandler(p, list, list2, data, value: number?)
	if not data then
		p.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.FailedToLogPlayerTileImpressions,
			{
				name = "SduiPlayerTileImpressionsHandler",
				message = "Missing collectionAnalyticsData"
			},
			p.appPage
		)
		return
	end

	if #list == 0 or #list2 == 0 then
		return
	end

	local itemsPerRow = data.itemsPerRow
	local v = {}
	local playerIds = {}
	local playerNames = {}
	local v2 = {}

	for _, item in list do
		local item2 = list2[item]
		local playerId

		if item2 then
			playerId = item2.playerId
		end

		if playerId == nil then
			continue
		end

		table.insert(v, item)
		table.insert(playerIds, playerId)
		table.insert(playerNames, item2.playerName or item2.name or item2.username or "")

		if not (typeof(value) == "number" and typeof(itemsPerRow) == "number" and itemsPerRow > 0) then
			continue
		end

		table.insert(v2, value + math.ceil(item / itemsPerRow) - 1)
	end

	if #playerIds == 0 then
		return
	end

	local userSearchSessionId = data.userSearchSessionId

	local v3 = {
		eventContext = data.eventContext or "playerSearch",
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = 0
	}

	local customFields = {
		tilePos = table.concat(v, ","),
		playerId = table.concat(playerIds, ","),
		playerName = table.concat(playerNames, ","),
		userSearchSessionId = 0,
		sortId = 0,
		sortPosition = 0,
		pageContext = 0,
		rowInSort = 0,
		locale = 0
	}
	local userSearchSessionId2

	if userSearchSessionId ~= nil then
		userSearchSessionId2 = tostring(userSearchSessionId)
	end

	customFields.userSearchSessionId = userSearchSessionId2
	local sortId

	if data.collectionId ~= nil then
		sortId = tostring(data.collectionId)
	end

	customFields.sortId = sortId

	customFields.sortPosition = data.collectionPosition
	customFields.pageContext = data.pageContext or p.appPage
	local rowInSort

	if #v2 > 0 then
		rowInSort = table.concat(v2, ",")
	end

	customFields.rowInSort = rowInSort
	customFields.locale = LocalizationService.RobloxLocaleId
	v3.customFields = customFields
	TelemetryService:LogEvent({
		eventName = "playerTileImpressions",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 7, 17 },
		description = "Fired when player tiles are visible in an SDUI collection"
	}, v3)
end

return SduiPlayerTileImpressionsHandler
