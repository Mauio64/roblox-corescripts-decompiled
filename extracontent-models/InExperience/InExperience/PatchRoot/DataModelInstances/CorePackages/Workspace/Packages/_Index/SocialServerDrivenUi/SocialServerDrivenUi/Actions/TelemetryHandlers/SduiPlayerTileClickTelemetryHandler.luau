local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local getActionTelemetryFieldValue = require(Parent.SduiCoreSystem).getActionTelemetryFieldValue
local calculateRowPositionFields = require(Parent.UnifiedLogging).calculateRowPositionFields
local v7 = game:DefineFastInt("SduiPlayerTileClickThrottlingHundredthsPercent", 10000)

local function SduiPlayerTileClickTelemetryHandler(p1, p2, p3) -- line: 22
	-- upvalues: getActionTelemetryFieldValue (copy), calculateRowPositionFields (copy), TelemetryService (copy), v7 (copy), HttpService (copy), LocalizationService (copy)
	local v12 = getActionTelemetryFieldValue(p1, p2, "profileType")

	if v12 ~= nil and v12 ~= "User" then
		return
	end

	local v13 = getActionTelemetryFieldValue(p1, p2, "playerId")

	if v13 == nil then
		return
	end

	local v14 = getActionTelemetryFieldValue(p1, p2, "tilePos") or getActionTelemetryFieldValue(p1, p2, "itemPosition")
	local v15 = getActionTelemetryFieldValue(p1, p2, "userSearchSessionId")
	local v16 = if v15 == nil then nil else tostring(v15)
	local v17 = getActionTelemetryFieldValue(p1, p2, "collectionId")
	local v18 = getActionTelemetryFieldValue(p1, p2, "collectionPosition")
	local v19 = if not p2 or not p2.getCollectionData then nil else p2.getCollectionData()
	local v20 = if not v19 then nil else v19.itemsPerRow
	local v21 = if not v19 then nil else v19.startRowNumber
	local v22 = calculateRowPositionFields(v14, v20, v21)
	local v23 = getActionTelemetryFieldValue(p1, p2, "feedRowNumber") or if v22.rowOnPage == -1 then nil else v22.rowOnPage
	local v24 = getActionTelemetryFieldValue(p1, p2, "positionInRow") or if v22.positionInRow == -1 then nil else v22.positionInRow
	local v25 = getActionTelemetryFieldValue(p1, p2, "rowInSort") or if v22.rowInSort == -1 then nil else v22.rowInSort

	TelemetryService:LogEvent({
		eventName = "playerTileClick",
		description = "Fired when a player tile is clicked in an SDUI collection",
		backends = { "EventIngest" },
		throttlingPercentage = v7,
		lastUpdated = {
			26,
			7,
			17
		}
	}, {
		eventContext = getActionTelemetryFieldValue(p1, p2, "eventContext") or "playerSearch",
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = {
			actionType = "OpenProfile",
			playerId = v13,
			tilePos = v14,
			contentType = getActionTelemetryFieldValue(p1, p2, "contentType") or "User",
			pageContext = getActionTelemetryFieldValue(p1, p2, "pageContext") or p3.appPage,
			interactionUuid = HttpService:GenerateGUID(false),
			locale = LocalizationService.RobloxLocaleId,
			userSearchSessionId = v16,
			feedRowNumber = v23,
			positionInRow = v24,
			rowInSort = v25,
			sortId = if v17 == nil then nil else tostring(v17),
			sortPosition = v18
		}
	})
end

return SduiPlayerTileClickTelemetryHandler
