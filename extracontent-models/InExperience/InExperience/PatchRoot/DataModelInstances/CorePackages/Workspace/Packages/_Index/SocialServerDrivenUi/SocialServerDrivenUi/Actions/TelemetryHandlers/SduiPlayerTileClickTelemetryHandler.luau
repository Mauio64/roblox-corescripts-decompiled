local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local UnifiedLogging = require(parent.UnifiedLogging)
local calculateRowPositionFields = UnifiedLogging.calculateRowPositionFields

local defineFastInt = game:DefineFastInt("SduiPlayerTileClickThrottlingHundredthsPercent", 10000)

local function SduiPlayerTileClickTelemetryHandler(p, p2, p3)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "profileType")

	if actionTelemetryFieldValue ~= nil and actionTelemetryFieldValue ~= "User" then
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "playerId")

	if actionTelemetryFieldValue2 == nil then
		return
	end

	local tilePos = getActionTelemetryFieldValue(p, p2, "tilePos")
		or getActionTelemetryFieldValue(p, p2, "itemPosition")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p, p2, "userSearchSessionId")
	local userSearchSessionId

	if actionTelemetryFieldValue3 ~= nil then
		userSearchSessionId = tostring(actionTelemetryFieldValue3)
	end

	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(p, p2, "collectionId")
	local actionTelemetryFieldValue5 = getActionTelemetryFieldValue(p, p2, "collectionPosition")
	local v

	if p2 and p2.getCollectionData then
		v = p2.getCollectionData()
	end

	local itemsPerRow

	if v then
		itemsPerRow = v.itemsPerRow
	end

	local v2

	if v then
		v2 = v.startRowNumber
	end

	local v3 = calculateRowPositionFields(tilePos, itemsPerRow, v2)

	local feedRowNumber = getActionTelemetryFieldValue(p, p2, "feedRowNumber")

	if not feedRowNumber then
		feedRowNumber = if v3.rowOnPage ~= -1 then v3.rowOnPage else nil
	end

	local positionInRow = getActionTelemetryFieldValue(p, p2, "positionInRow")

	if not positionInRow then
		if v3.positionInRow == -1 then
			positionInRow = nil
		else
			positionInRow = v3.positionInRow
		end
	end

	local rowInSort = getActionTelemetryFieldValue(p, p2, "rowInSort")

	if not rowInSort then
		rowInSort = if v3.rowInSort ~= -1 then v3.rowInSort else nil
	end

	local v4 = {
		eventContext = getActionTelemetryFieldValue(p, p2, "eventContext") or "playerSearch",
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = 0
	}

	local customFields = {
		playerId = actionTelemetryFieldValue2,
		tilePos = tilePos,
		contentType = getActionTelemetryFieldValue(p, p2, "contentType") or "User",
		actionType = "OpenProfile",
		pageContext = getActionTelemetryFieldValue(p, p2, "pageContext") or p3.appPage,
		interactionUuid = HttpService:GenerateGUID(false),
		locale = LocalizationService.RobloxLocaleId,
		userSearchSessionId = userSearchSessionId,
		feedRowNumber = feedRowNumber,
		positionInRow = positionInRow,
		rowInSort = rowInSort,
		sortId = 0,
		sortPosition = 0
	}
	local sortId

	if actionTelemetryFieldValue4 ~= nil then
		sortId = tostring(actionTelemetryFieldValue4)
	end

	customFields.sortId = sortId
	customFields.sortPosition = actionTelemetryFieldValue5
	v4.customFields = customFields
	TelemetryService:LogEvent({
		eventName = "playerTileClick",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 7, 17 },
		description = "Fired when a player tile is clicked in an SDUI collection"
	}, v4)
end

return SduiPlayerTileClickTelemetryHandler
