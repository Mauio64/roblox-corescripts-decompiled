local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local LocalizationService = game:GetService("LocalizationService")

local getActionTelemetryFieldValue = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem").getActionTelemetryFieldValue
local calculateRowPositionFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/UnifiedLogging").calculateRowPositionFields

local defineFastInt = game:DefineFastInt("SduiPlayerTileClickThrottlingHundredthsPercent", 10000)

local function SduiPlayerTileClickTelemetryHandler(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "profileType")

	if actionTelemetryFieldValue ~= nil and actionTelemetryFieldValue ~= "User" then
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "playerId")

	if actionTelemetryFieldValue2 == nil then
		return
	end

	local v5 = getActionTelemetryFieldValue(p2, p3, "tilePos")
		or getActionTelemetryFieldValue(p2, p3, "itemPosition")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p2, p3, "userSearchSessionId")
	local v6 = if actionTelemetryFieldValue3 ~= nil then tostring(actionTelemetryFieldValue3) else nil

	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(p2, p3, "collectionId")
	local actionTelemetryFieldValue5 = getActionTelemetryFieldValue(p2, p3, "collectionPosition")

	local v7 = if p3 and p3.getCollectionData then p3.getCollectionData() else nil

	local itemsPerRow = if v7 then v7.itemsPerRow else nil
	local v8 = if v7 then v7.startRowNumber else nil
	local v9 = calculateRowPositionFields(v5, itemsPerRow, v8)

	local v10 = getActionTelemetryFieldValue(p2, p3, "feedRowNumber")

	if not v10 then
		v10 = if v9.rowOnPage ~= -1 then v9.rowOnPage else nil
	end

	local v11 = getActionTelemetryFieldValue(p2, p3, "positionInRow")

	if not v11 then
		v11 = if v9.positionInRow ~= -1 then v9.positionInRow else nil
	end

	local v12 = getActionTelemetryFieldValue(p2, p3, "rowInSort")

	if not v12 then
		v12 = if v9.rowInSort ~= -1 then v9.rowInSort else nil
	end

	local v15 = {
		eventContext = getActionTelemetryFieldValue(p2, p3, "eventContext") or "playerSearch",
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = 0
	}

	local v16 = {
		playerId = actionTelemetryFieldValue2,
		tilePos = v5,
		contentType = getActionTelemetryFieldValue(p2, p3, "contentType") or "User",
		actionType = "OpenProfile",
		pageContext = getActionTelemetryFieldValue(p2, p3, "pageContext") or p4.appPage,
		interactionUuid = HttpService:GenerateGUID(false),
		locale = LocalizationService.RobloxLocaleId,
		userSearchSessionId = v6,
		feedRowNumber = v10,
		positionInRow = v11,
		rowInSort = v12,
		sortId = 0,
		sortPosition = 0
	}

	local v17 = if actionTelemetryFieldValue4 ~= nil then tostring(actionTelemetryFieldValue4) else nil
	v16.sortId = v17
	v16.sortPosition = actionTelemetryFieldValue5
	v15.customFields = v16
	TelemetryService:LogEvent({
		eventName = "playerTileClick",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 7, 17 },
		description = "Fired when a player tile is clicked in an SDUI collection"
	}, v15)
end

return SduiPlayerTileClickTelemetryHandler
