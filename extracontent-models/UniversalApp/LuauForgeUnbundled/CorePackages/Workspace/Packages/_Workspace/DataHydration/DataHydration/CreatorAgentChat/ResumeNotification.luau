local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/RobloxAppLocales").Localization
local parseFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/parseFrame")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local v5 = {
	studio_ask_user = true,
	ask_user = true,
	present_plan = true,
	propose_plan = true
}

local function extractRawFrame(value)
	if typeof(value) == "string" then
		return value
	end

	if typeof(value) ~= "table" then
		return nil
	end

	for k, v6 in { "frame", "payload", "message", "data", "body" } do
		local v7 = value[v6]

		if typeof(v7) == "string" and v7 ~= "" then
			return v7
		end
	end

	return nil
end

local function normalizeUniverseId(value)
	if typeof(value) == "number" and value ~= 0 then
		return value
	end

	if typeof(value) ~= "string" or value == "" then
		return nil
	end

	local v6 = tonumber(value)

	if v6 == nil or v6 == 0 then
		return nil
	end

	return v6
end

local function getUniverseId(p2)
	local universeId = p2.universeId

	if typeof(universeId) ~= "number" or universeId == 0 then
		if typeof(universeId) == "string" and universeId ~= "" then
			universeId = tonumber(universeId)

			if universeId == nil or universeId == 0 then
				universeId = nil
			end
		else
			universeId = nil
		end
	end

	if universeId ~= nil then
		return universeId
	end

	local roblox = p2._meta and p2._meta._roblox

	if typeof(roblox) ~= "table" then
		return nil
	end

	local universeId2 = roblox.universeId

	if typeof(universeId2) == "number" and universeId2 ~= 0 then
		return universeId2
	end

	if typeof(universeId2) ~= "string" or universeId2 == "" then
		return nil
	end

	local v6 = tonumber(universeId2)

	if v6 == nil or v6 == 0 then
		return nil
	end

	return v6
end

local function valueLooksLikeLocalTool(value): boolean
	return typeof(value) == "string" and v5[string.lower(value)] == true
end

local function updateLooksLikeLocalTool(data)
	local kind = data.kind
	local v6 = typeof(kind) == "string" and v5[string.lower(kind)] == true

	if v6 then
		return true
	end

	local title = data.title
	local v7 = typeof(title) == "string" and v5[string.lower(title)] == true

	if v7 then
		return true
	end

	local rawInput = data.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	local name = rawInput.name
	local v8 = typeof(name) == "string" and v5[string.lower(name)] == true

	if v8 then
		return v8
	end

	local toolName = rawInput.toolName
	v8 = typeof(toolName) == "string" and v5[string.lower(toolName)] == true
	return v8
end

local function getSessionUpdate(p2)
	if p2.kind ~= "notification" then
		return nil, nil, nil, nil
	end

	local notification = p2.notification

	if notification.method ~= AcpProtocol.Notifications.SessionUpdate then
		return nil, nil, nil, nil
	end

	local params = notification.params
	local sessionId = params.sessionId
	local update = params.update

	if typeof(sessionId) ~= "string" or sessionId == "" or typeof(update) ~= "table" then
		return nil, nil, nil, nil
	end

	local universeId = params.universeId

	if typeof(universeId) ~= "number" or universeId == 0 then
		if typeof(universeId) == "string" and universeId ~= "" then
			universeId = tonumber(universeId)

			if universeId == nil or universeId == 0 then
				universeId = nil
			end
		else
			universeId = nil
		end
	end

	if universeId ~= nil then
		return update, sessionId, universeId, params.pinForBuild == true
	end

	local roblox = params._meta and params._meta._roblox

	if typeof(roblox) == "table" then
		universeId = roblox.universeId

		if typeof(universeId) ~= "number" or universeId == 0 then
			if typeof(universeId) == "string" and universeId ~= "" then
				universeId = tonumber(universeId)

				if universeId == nil or universeId == 0 then
					universeId = nil
				end
			else
				universeId = nil
			end
		end
	else
		universeId = nil
	end

	return update, sessionId, universeId, params.pinForBuild == true
end

local function classifyFrame(p2)
	local sessionUpdate, v6, v7, v8 = getSessionUpdate(p2)

	if sessionUpdate == nil or v6 == nil or v8 ~= true then
		return nil
	end

	if sessionUpdate.sessionUpdate == "state_change" and sessionUpdate.state == "idle" then
		return { kind = "turn_end", sessionId = v6, universeId = v7 }
	end

	if sessionUpdate.sessionUpdate ~= "tool_call_update" then
		return nil
	end

	local status = sessionUpdate.status

	if not (status ~= "completed" and status ~= "failed" and status ~= "cancelled") then
		return nil
	end

	local kind = sessionUpdate.kind
	local v9 = typeof(kind) == "string" and v5[string.lower(kind)] == true
	local v10

	if v9 then
		v10 = true
	else
		local title = sessionUpdate.title
		local v11 = typeof(title) == "string" and v5[string.lower(title)] == true

		if v11 then
			v10 = true
		else
			local rawInput = sessionUpdate.rawInput

			if typeof(rawInput) == "table" then
				local name = rawInput.name
				v10 = typeof(name) == "string" and v5[string.lower(name)] == true

				if not v10 then
					local toolName = rawInput.toolName
					v10 = typeof(toolName) == "string" and v5[string.lower(toolName)] == true
				end
			else
				v10 = false
			end
		end
	end

	if v10 then
		local toolCallId = sessionUpdate.toolCallId

		if typeof(toolCallId) ~= "string" or toolCallId == "" then
			toolCallId = nil
		end

		return {
			kind = "local_tool_call",
			sessionId = v6,
			universeId = v7,
			toolCallId = toolCallId
		}
	end

	return nil
end

local function getResumeDeepLink(data)
	local v6 = {}

	if data.universeId ~= nil then
		table.insert(v6, `universeid={HttpService:UrlEncode((tostring(data.universeId)))}`)
	end

	table.insert(v6, `sessionid={HttpService:UrlEncode(data.sessionId)}`)

	return `roblox://navigation/build?{table.concat(v6, "&")}`
end

local function getToastCopy(data)
	local v6 = data.kind == "local_tool_call"
	local v7 = localization.new(LocalizationService.RobloxLocaleId)
	return {
		title = v7:Format(v6 and "Feature.Build.Notification.Title.NeedInput" or "Feature.Build.Notification.Title.Finished"),
		label = v7:Format(v6 and "Feature.Build.Notification.Message.Continue" or "Feature.Build.Notification.Message.Review"),
		dismiss = v7:Format("Feature.Build.Action.Dismiss"),
		resume = v7:Format("Feature.Build.Action.Resume")
	}
end

local function getActionEventParams(data)
	return HttpService:JSONEncode({
		sessionId = data.sessionId,
		universeId = data.universeId,
		kind = data.kind,
		deepLink = getResumeDeepLink(data)
	})
end

local function getToastVisualItems(data, toastCopy, jsonEncode)
	local toastVisualItems = {}

	if data.universeId ~= nil then
		table.insert(toastVisualItems, {
			thumbnail = {
				id = tostring(data.universeId),
				idType = "gameThumbnail",
				visualItemType = "thumbnail"
			}
		})
	end

	table.insert(toastVisualItems, {
		textBody = {
			title = { text = toastCopy.title },
			label = { text = toastCopy.label },
			actions = {},
			eventName = "CreatorAgentResume",
			visualItemType = "textBody",
			actionEventParams = jsonEncode
		}
	})

	table.insert(toastVisualItems, {
		button = {
			label = { text = toastCopy.dismiss },
			actions = {
				{ actionType = "dismiss" }
			},
			buttonStyle = "Secondary",
			eventName = "CreatorAgentResumeDismiss",
			visualItemType = "button"
		}
	})

	table.insert(toastVisualItems, {
		button = {
			label = { text = toastCopy.resume },
			actions = {},
			buttonStyle = "Primary",
			eventName = "CreatorAgentResume",
			visualItemType = "button",
			actionEventParams = jsonEncode
		}
	})

	return toastVisualItems
end

return {
	NotificationType = "CreatorAgentResume",
	ResumeEventName = "CreatorAgentResume",
	CapRtnNamespace = AcpProtocol.CapRtnNamespace,
	classifyFrame = classifyFrame,
	classifyRtnDetail = function(p2)
		local v6 = extractRawFrame(p2)

		if v6 == nil then
			return nil
		end

		local v7 = parseFrame(v6)

		if v7 == nil then
			return nil
		end

		return classifyFrame(v7)
	end,
	targetMatchesNotification = function(p2, p3): boolean
		if p2 == nil then
			return false
		end

		if p2.sessionId ~= nil and p2.sessionId ~= "" and p2.sessionId == p3.sessionId then
			return true
		end

		return p2.universeId ~= nil and p3.universeId ~= nil and p2.universeId == p3.universeId
	end,
	getNotificationId = function(data)
		if data.kind == "local_tool_call" and data.toolCallId ~= nil then
			return `CreatorAgentResume-{data.sessionId}-{data.toolCallId}`
		end

		return `CreatorAgentResume-{data.sessionId}-{data.kind}`
	end,
	getResumeDeepLink = getResumeDeepLink,
	buildToastNotification = function(data)
		local toastCopy = getToastCopy(data)
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		local jsonEncode = HttpService:JSONEncode({
			sessionId = data.sessionId,
			universeId = data.universeId,
			kind = data.kind,
			deepLink = getResumeDeepLink(data)
		})
		local v7 = if data.kind == "local_tool_call" and data.toolCallId ~= nil then `CreatorAgentResume-{data.sessionId}-{data.toolCallId}` else `CreatorAgentResume-{data.sessionId}-{data.kind}`

		return {
			notificationType = "CreatorAgentResume",
			deliverTimestamp = unixTimestampMillis,
			notificationReceivedTimestampMs = unixTimestampMillis,
			content = {
				currentState = "Default",
				notificationType = "CreatorAgentResume",
				id = v7,
				minVersion = 0,
				priority = 1,
				clientEventsPayload = {},
				states = {
					Default = {
						layoutKey = "CreatorAgentResume",
						name = "Default",
						timeOnScreenMs = 12000,
						visualItems = getToastVisualItems(data, toastCopy, jsonEncode)
					}
				}
			}
		}
	end
}
