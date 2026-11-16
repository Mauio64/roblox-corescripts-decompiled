local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("DataHydration").Parent

local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local parseFrame = require(script.Parent.Acp.parseFrame)
require(script.Parent.types)

local v = { studio_ask_user = true, ask_user = true, present_plan = true, propose_plan = true }

local function extractRawFrame(value)
	if typeof(value) == "string" then
		return value
	end

	if typeof(value) ~= "table" then
		return nil
	end

	for _, v2 in { "frame", "payload", "message", "data", "body" } do
		local v3 = value[v2]

		if typeof(v3) == "string" and v3 ~= "" then
			return v3
		end
	end

	return nil
end

local function normalizeUniverseId(universeId) -- 1 equivalent call inferred from this helper
	if typeof(universeId) == "number" and universeId ~= 0 then
		return universeId
	end

	if typeof(universeId) ~= "string" or universeId == "" then
		return nil
	end

	local v2 = tonumber(universeId)
	return if not (v2 == nil or v2 == 0) then v2 else nil
end

local function getUniverseId(p)
	local universeId = p.universeId

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

	local roblox = p._meta and p._meta._roblox

	if typeof(roblox) ~= "table" then
		return nil
	end

	return normalizeUniverseId(roblox.universeId) -- inferred equivalent call
end

local function valueLooksLikeLocalTool(value): boolean -- 8 equivalent calls inferred from this helper
	return typeof(value) == "string" and v[string.lower(value)] == true
end

local function updateLooksLikeLocalTool(data)
	if valueLooksLikeLocalTool(data.kind) then -- inferred equivalent call
		return true
	end

	if valueLooksLikeLocalTool(data.title) then -- inferred equivalent call
		return true
	end

	local rawInput = data.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	return valueLooksLikeLocalTool(rawInput.name) or valueLooksLikeLocalTool(rawInput.toolName) -- inferred equivalent call
end

local function getSessionUpdate(p)
	if p.kind ~= "notification" then
		return nil, nil, nil, nil
	end

	local notification = p.notification

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

local function classifyFrame(p)
	local sessionUpdate, sessionId, universeId, v2 = getSessionUpdate(p)

	if sessionUpdate == nil or sessionId == nil or v2 ~= true then
		return nil
	end

	if sessionUpdate.sessionUpdate == "state_change" and sessionUpdate.state == "idle" then
		return { kind = "turn_end", sessionId = sessionId, universeId = universeId }
	end

	if sessionUpdate.sessionUpdate ~= "tool_call_update" then
		return nil
	end

	local status = sessionUpdate.status

	if not (status ~= "completed" and status ~= "failed" and status ~= "cancelled") then
		return nil
	end

	local v3 = valueLooksLikeLocalTool(sessionUpdate.kind) -- inferred equivalent call
	local v4

	if v3 then
		v4 = true
	elseif valueLooksLikeLocalTool(sessionUpdate.title) then -- inferred equivalent call
		v4 = true
	else
		local rawInput = sessionUpdate.rawInput

		if typeof(rawInput) == "table" then
			v4 = valueLooksLikeLocalTool(rawInput.name) or valueLooksLikeLocalTool(rawInput.toolName) -- inferred equivalent call
		else
			v4 = false
		end
	end

	if v4 then
		local toolCallId = sessionUpdate.toolCallId

		if typeof(toolCallId) ~= "string" or toolCallId == "" then
			toolCallId = nil
		end

		return {
			kind = "local_tool_call",
			sessionId = sessionId,
			universeId = universeId,
			toolCallId = toolCallId
		}
	end

	return nil
end

local function getNotificationId(data) -- 1 equivalent call inferred from this helper
	if data.kind == "local_tool_call" and data.toolCallId ~= nil then
		return `CreatorAgentResume-{data.sessionId}-{data.toolCallId}`
	end

	return `CreatorAgentResume-{data.sessionId}-{data.kind}`
end

local function getResumeDeepLink(data)
	local v2 = {}

	if data.universeId ~= nil then
		table.insert(v2, `universeid={HttpService:UrlEncode((tostring(data.universeId)))}`)
	end

	table.insert(v2, `sessionid={HttpService:UrlEncode(data.sessionId)}`)

	return `roblox://navigation/build?{table.concat(v2, "&")}`
end

local function getToastCopy(data)
	local v2 = data.kind == "local_tool_call"
	local v3 = Localization.new(LocalizationService.RobloxLocaleId)
	return {
		title = v3:Format(v2 and "Feature.Build.Notification.Title.NeedInput" or "Feature.Build.Notification.Title.Finished"),
		label = v3:Format(v2 and "Feature.Build.Notification.Message.Continue" or "Feature.Build.Notification.Message.Review"),
		dismiss = v3:Format("Feature.Build.Action.Dismiss"),
		resume = v3:Format("Feature.Build.Action.Resume")
	}
end

local function getActionEventParams(data) -- 1 equivalent call inferred from this helper
	return HttpService:JSONEncode({
		sessionId = data.sessionId,
		universeId = data.universeId,
		kind = data.kind,
		deepLink = getResumeDeepLink(data)
	})
end

local function getToastVisualItems(data, toastCopy, actionEventParams: string)
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
			actionEventParams = actionEventParams
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
			actionEventParams = actionEventParams
		}
	})

	return toastVisualItems
end

local ResumeNotification = {}
ResumeNotification.NotificationType = "CreatorAgentResume"
ResumeNotification.ResumeEventName = "CreatorAgentResume"
ResumeNotification.CapRtnNamespace = AcpProtocol.CapRtnNamespace
ResumeNotification.classifyFrame = classifyFrame

function ResumeNotification.classifyRtnDetail(p)
	local v2 = extractRawFrame(p)

	if v2 == nil then
		return nil
	end

	local v3 = parseFrame(v2)

	if v3 == nil then
		return nil
	end

	return classifyFrame(v3)
end

function ResumeNotification.targetMatchesNotification(p, p2): boolean
	if p == nil then
		return false
	end

	if p.sessionId ~= nil and p.sessionId ~= "" and p.sessionId == p2.sessionId then
		return true
	end

	return p.universeId ~= nil and p2.universeId ~= nil and p.universeId == p2.universeId
end

ResumeNotification.getNotificationId = getNotificationId
ResumeNotification.getResumeDeepLink = getResumeDeepLink

function ResumeNotification.buildToastNotification(data)
	local toastCopy = getToastCopy(data)
	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	local actionEventParams = getActionEventParams(data) -- inferred equivalent call
	return {
		notificationType = "CreatorAgentResume",
		deliverTimestamp = unixTimestampMillis,
		notificationReceivedTimestampMs = unixTimestampMillis,
		content = {
			currentState = "Default",
			notificationType = "CreatorAgentResume",
			id = getNotificationId(data), -- inferred equivalent call
			minVersion = 0,
			priority = 1,
			clientEventsPayload = {},
			states = {
				Default = {
					layoutKey = "CreatorAgentResume",
					name = "Default",
					timeOnScreenMs = 12000,
					visualItems = getToastVisualItems(data, toastCopy, actionEventParams)
				}
			}
		}
	}
end

return ResumeNotification
