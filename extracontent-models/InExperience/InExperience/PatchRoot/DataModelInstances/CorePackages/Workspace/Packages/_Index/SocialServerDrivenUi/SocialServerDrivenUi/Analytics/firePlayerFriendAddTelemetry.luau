local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local getActionTelemetryFieldValue = require(Parent.SduiCoreSystem).getActionTelemetryFieldValue
local v6 = game:DefineFastInt("SduiPlayerFriendAddThrottlingHundredthsPercent", 10000)

local function firePlayerFriendAddTelemetry(s1: string, p1, p2) -- line: 20
	-- upvalues: getActionTelemetryFieldValue (copy), TelemetryService (copy), v6 (copy), HttpService (copy), LocalizationService (copy)
	local v11 = getActionTelemetryFieldValue(nil, p1, "tilePos") or getActionTelemetryFieldValue(nil, p1, "itemPosition")
	local v12 = getActionTelemetryFieldValue(nil, p1, "pageContext") or if not p2 then nil else p2.appPage
	local v13 = getActionTelemetryFieldValue(nil, p1, "eventContext") or "playerSearch"
	local v14 = getActionTelemetryFieldValue(nil, p1, "contentType") or "User"
	local v15 = getActionTelemetryFieldValue(nil, p1, "userSearchSessionId")
	local v16 = if v15 == nil then nil else tostring(v15)
	local v17 = getActionTelemetryFieldValue(nil, p1, "collectionId")
	local v18 = getActionTelemetryFieldValue(nil, p1, "collectionPosition")
	local v19 = if not p1 or not p1.getCollectionData then nil else p1.getCollectionData()
	local v20 = if not v19 then nil else v19.itemsPerRow
	local v21 = if not v19 then nil else v19.startRowNumber
	local v22 = nil
	local v23 = nil
	local v24 = nil

	if typeof(v11) == "number" and (v11 > 0 and typeof(v20) == "number" and v20 > 0) then
		v24 = math.ceil(v11 / v20)
		v23 = (v11 - 1) % v20 + 1

		if typeof(v21) == "number" then
			v22 = v21 + v24 - 1
		end
	end

	local v25 = getActionTelemetryFieldValue(nil, p1, "feedRowNumber") or v22
	local v26 = getActionTelemetryFieldValue(nil, p1, "positionInRow") or v23
	local v27 = getActionTelemetryFieldValue(nil, p1, "rowInSort") or v24

	TelemetryService:LogEvent({
		eventName = "playerFriendAdd",
		description = "Fired when a player tile friend request is sent in an SDUI collection",
		backends = { "EventIngest" },
		throttlingPercentage = v6,
		lastUpdated = {
			26,
			7,
			17
		}
	}, {
		eventContext = v13,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = {
			actionType = "RequestFriendship",
			playerId = s1,
			contentType = v14,
			interactionUuid = HttpService:GenerateGUID(false),
			tilePos = v11,
			pageContext = v12,
			userSearchSessionId = v16,
			feedRowNumber = v25,
			positionInRow = v26,
			rowInSort = v27,
			sortId = if v17 == nil then nil else tostring(v17),
			sortPosition = v18,
			locale = LocalizationService.RobloxLocaleId
		}
	})
end

return firePlayerFriendAddTelemetry
