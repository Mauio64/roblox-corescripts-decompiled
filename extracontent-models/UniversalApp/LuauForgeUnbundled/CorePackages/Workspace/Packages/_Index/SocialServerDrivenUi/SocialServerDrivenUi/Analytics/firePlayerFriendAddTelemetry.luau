local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local LocalizationService = game:GetService("LocalizationService")

local getActionTelemetryFieldValue = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem").getActionTelemetryFieldValue

local defineFastInt = game:DefineFastInt("SduiPlayerFriendAddThrottlingHundredthsPercent", 10000)

local function firePlayerFriendAddTelemetry(p2, p3, p4)
	local v5 = getActionTelemetryFieldValue(nil, p3, "tilePos")
		or getActionTelemetryFieldValue(nil, p3, "itemPosition")
	local v6 = getActionTelemetryFieldValue(nil, p3, "pageContext")

	if not v6 then
		v6 = if p4 then p4.appPage else nil
	end

	local v7 = getActionTelemetryFieldValue(nil, p3, "eventContext") or "playerSearch"
	local v8 = getActionTelemetryFieldValue(nil, p3, "contentType") or "User"
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(nil, p3, "userSearchSessionId")
	local v9 = if actionTelemetryFieldValue ~= nil then tostring(actionTelemetryFieldValue) else nil

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(nil, p3, "collectionId")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(nil, p3, "collectionPosition")

	local v10 = if p3 and p3.getCollectionData then p3.getCollectionData() else nil

	local itemsPerRow = if v10 then v10.itemsPerRow else nil
	local startRowNumber = if v10 then v10.startRowNumber else nil

	local v11 = nil
	local v12, v13

	if typeof(v5) == "number" and v5 > 0 and typeof(itemsPerRow) == "number" and itemsPerRow > 0 then
		v12 = math.ceil(v5 / itemsPerRow)
		v13 = (v5 - 1) % itemsPerRow + 1

		if typeof(startRowNumber) == "number" then
			v11 = startRowNumber + v12 - 1
		end
	end

	local v14 = getActionTelemetryFieldValue(nil, p3, "feedRowNumber") or v11

	local v15 = getActionTelemetryFieldValue(nil, p3, "positionInRow") or v13

	local v16 = getActionTelemetryFieldValue(nil, p3, "rowInSort") or v12

	local v20 = {
		playerId = p2,
		contentType = v8,
		actionType = "RequestFriendship",
		interactionUuid = HttpService:GenerateGUID(false),
		tilePos = v5,
		pageContext = v6,
		userSearchSessionId = v9,
		feedRowNumber = v14,
		positionInRow = v15,
		rowInSort = v16,
		sortId = 0,
		sortPosition = 0,
		locale = 0
	}

	local v21 = if actionTelemetryFieldValue2 ~= nil then tostring(actionTelemetryFieldValue2) else nil
	v20.sortId = v21
	v20.sortPosition = actionTelemetryFieldValue3
	v20.locale = LocalizationService.RobloxLocaleId
	TelemetryService:LogEvent({
		eventName = "playerFriendAdd",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 7, 17 },
		description = "Fired when a player tile friend request is sent in an SDUI collection"
	}, {
		eventContext = v7,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = v20
	})
end

return firePlayerFriendAddTelemetry
