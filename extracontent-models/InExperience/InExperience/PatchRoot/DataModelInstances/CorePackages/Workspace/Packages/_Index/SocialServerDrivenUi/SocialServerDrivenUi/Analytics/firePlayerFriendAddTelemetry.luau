local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local defineFastInt = game:DefineFastInt("SduiPlayerFriendAddThrottlingHundredthsPercent", 10000)

local function firePlayerFriendAddTelemetry(playerId: string, p, p2)
	local tilePos = getActionTelemetryFieldValue(nil, p, "tilePos")
		or getActionTelemetryFieldValue(nil, p, "itemPosition")
	local pageContext = getActionTelemetryFieldValue(nil, p, "pageContext")

	if not pageContext then
		pageContext = if p2 then p2.appPage else nil
	end

	local eventContext = getActionTelemetryFieldValue(nil, p, "eventContext") or "playerSearch"
	local contentType = getActionTelemetryFieldValue(nil, p, "contentType") or "User"
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(nil, p, "userSearchSessionId")
	local userSearchSessionId

	if actionTelemetryFieldValue ~= nil then
		userSearchSessionId = tostring(actionTelemetryFieldValue)
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(nil, p, "collectionId")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(nil, p, "collectionPosition")
	local v

	if p and p.getCollectionData then
		v = p.getCollectionData()
	end

	local itemsPerRow

	if v then
		itemsPerRow = v.itemsPerRow
	end

	local startRowNumber

	if v then
		startRowNumber = v.startRowNumber
	end

	local v2 = nil
	local v3, v4

	if typeof(tilePos) == "number" and tilePos > 0 and typeof(itemsPerRow) == "number" and itemsPerRow > 0 then
		v3 = math.ceil(tilePos / itemsPerRow)
		v4 = (tilePos - 1) % itemsPerRow + 1

		if typeof(startRowNumber) == "number" then
			v2 = startRowNumber + v3 - 1
		end
	end

	local feedRowNumber = getActionTelemetryFieldValue(nil, p, "feedRowNumber") or v2

	local positionInRow = getActionTelemetryFieldValue(nil, p, "positionInRow") or v4

	local rowInSort = getActionTelemetryFieldValue(nil, p, "rowInSort") or v3

	local customFields = {
		playerId = playerId,
		contentType = contentType,
		actionType = "RequestFriendship",
		interactionUuid = HttpService:GenerateGUID(false),
		tilePos = tilePos,
		pageContext = pageContext,
		userSearchSessionId = userSearchSessionId,
		feedRowNumber = feedRowNumber,
		positionInRow = positionInRow,
		rowInSort = rowInSort,
		sortId = 0,
		sortPosition = 0,
		locale = 0
	}
	local sortId

	if actionTelemetryFieldValue2 ~= nil then
		sortId = tostring(actionTelemetryFieldValue2)
	end

	customFields.sortId = sortId
	customFields.sortPosition = actionTelemetryFieldValue3
	customFields.locale = LocalizationService.RobloxLocaleId
	TelemetryService:LogEvent({
		eventName = "playerFriendAdd",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 7, 17 },
		description = "Fired when a player tile friend request is sent in an SDUI collection"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields
	})
end

return firePlayerFriendAddTelemetry
