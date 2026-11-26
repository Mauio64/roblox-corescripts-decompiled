local NotificationService = game:GetService("NotificationService")

local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/RealtimeDelivery")

local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")
local debug = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/debug")
local parseFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/parseFrame")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local robloxEventReceiver = nil
local v5 = 0
local v6 = nil
local count = 0

local function isConnectionState(p2): boolean
	return typeof(p2) == "EnumItem" and p2.EnumType == Enum.ConnectionState
end

local function previewString(value)
	if #value <= 4000 then
		return value
	end

	return string.sub(value, 1, 4000) .. "…"
end

local function summarizeDetail(preview, detailType)
	if typeof(preview) == "string" then
		local v7 = {
			shape = "string",
			length = #preview,
			preview = 0,
			detailType = 0
		}

		if not (#preview <= 4000) then
			preview = string.sub(preview, 1, 4000) .. "…"
		end

		v7.preview = preview
		v7.detailType = detailType
		return v7
	else
		if typeof(preview) ~= "table" then
			return {
				shape = typeof(preview),
				value = tostring(preview),
				detailType = detailType
			}
		end

		local v7 = {}

		for k in preview do
			table.insert(v7, k)
		end

		table.sort(v7)

		return { shape = "table", keys = v7, detailType = detailType }
	end
end

local function extractRawFrame(value)
	if typeof(value) == "string" then
		return value
	end

	if typeof(value) ~= "table" then
		return nil
	end

	for k, v7 in { "frame", "payload", "message", "data", "body" } do
		local v8 = value[v7]

		if typeof(v8) == "string" and v8 ~= "" then
			return v8
		end
	end

	return nil
end

local function extractRtnSequenceNumber(p2)
	if typeof(p2) == "table" then
		return p2.sequence_number
	end

	return nil
end

local function describeParsedFrame(data)
	if typeof(data) ~= "table" then
		return { kind = "unknown" }
	end

	if data.kind == "notification" and typeof(data.notification) == "table" then
		local v7 = { kind = "notification", method = data.notification.method }

		local params = data.notification.params

		if typeof(params) ~= "table" then
			return v7
		end

		v7.sessionId = params.sessionId
		local update = params.update

		if typeof(update) ~= "table" then
			return v7
		end

		if typeof(update.sessionUpdate) == "string" then
			v7.sessionUpdate = update.sessionUpdate
		end

		if update.sessionUpdate == "state_change" then
			v7.state = update.state
			v7.stopReason = update.stop_reason
		end

		return v7
	elseif data.kind == "response" and typeof(data.response) == "table" then
		return {
			kind = "response",
			id = data.response.id,
			hasError = typeof(data.response.error) == "table"
		}
	else
		return { kind = data.kind }
	end
end

local function onCapConnectionState(p2, p3, p4)
	debug.log("info", "CAP RTN connection state", {
		namespace = AcpProtocol.CapRtnNamespace,
		connectionState = tostring(p2),
		sequenceNumber = p3,
		seqByNamespace = p4
	})
end

local function onSignalRConnectionState(p2, p3, p4)
	local v7 = if typeof(p4) == "table" then p4[AcpProtocol.CapRtnNamespace] else nil
	debug.log("info", "SignalR connection state", {
		connectionState = tostring(p2),
		sequenceNumber = p3,
		capNamespace = AcpProtocol.CapRtnNamespace,
		capSequenceNumber = v7
	})
end

local function onCapEvent(p2, p3, p4)
	count += 1
	local v7 = count

	local log = debug.log
	local v10 = {
		namespace = AcpProtocol.CapRtnNamespace,
		messageIndex = v7,
		sequenceNumber = 0,
		summary = 0
	}
	local v11 = if typeof(p3) == "table" then p3.sequence_number else nil

	v10.sequenceNumber = v11
	v10.summary = summarizeDetail(p3, p4)
	log("info", "CAP RTN message received", v10)

	local v12 = extractRawFrame(p3)

	if v12 == nil then
		debug.log("warn", "CAP RTN message has no parseable frame field", {
			namespace = AcpProtocol.CapRtnNamespace,
			messageIndex = v7,
			summary = summarizeDetail(p3, p4),
			hint = "Expected string body or table key frame|payload|message|data|body"
		})

		return
	end

	local log2 = debug.log
	local v15 = {
		namespace = AcpProtocol.CapRtnNamespace,
		messageIndex = v7,
		length = #v12,
		preview = 0
	}
	local v16 = if #v12 <= 4000 then v12 else string.sub(v12, 1, 4000) .. "…"

	v15.preview = v16
	log2("info", "CAP RTN raw frame", v15)

	local v17 = parseFrame(v12)

	if v17 == nil then
		local log3 = debug.log
		local v20 = {
			messageIndex = v7,
			preview = 0,
			hint = "Expected JSON-RPC notification or response"
		}

		if not (#v12 <= 4000) then
			v12 = string.sub(v12, 1, 4000) .. "…"
		end

		v20.preview = v12
		log3("warn", "CAP frame dropped (parseFrame returned nil)", v20)
	else
		local v18 = describeParsedFrame(v17)
		debug.log("info", "CAP frame ingested", { messageIndex = v7, parsed = v18 })

		local ingestFrame = p2.ingestFrame
		local v20 = if typeof(p3) == "table" then p3.sequence_number else nil

		ingestFrame(v17, { sequenceNumber = v20 })

		if v17.kind == "response" then
			debug.log("info", "CAP response ingested", {
				messageIndex = v7,
				parsed = v18
			})

			return
		end

		local sessionId = v18.sessionId
		local function logTurnSnapshot(p5)
			if typeof(sessionId) ~= "string" then
				return
			end

			local activeTurnHandle = p2.getActiveTurnHandle(sessionId)

			if activeTurnHandle == nil then
				return
			end

			debug.log("info", p5, {
				messageIndex = v7,
				turn = debug.formatTurnState(activeTurnHandle.state(false))
			})
		end

		if v18.sessionUpdate == "agent_message_chunk" or v18.sessionUpdate == "state_change" then
			logTurnSnapshot(`CAP turn state after {v18.sessionUpdate}`)
		end
	end
end

local function onNamespaceSignal(p2, p3, p4, p5)
	local v7 = typeof(p3) == "EnumItem" and p3.EnumType == Enum.ConnectionState

	if v7 then
		debug.log("info", "CAP RTN connection state", {
			namespace = AcpProtocol.CapRtnNamespace,
			connectionState = tostring(p3),
			sequenceNumber = p4,
			seqByNamespace = p5
		})
	else
		onCapEvent(p2, p3, p4)
	end
end

local function ensureReceiver()
	if robloxEventReceiver == nil then
		robloxEventReceiver = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
	end
end

local function subscribeCapNamespace(p2)
	local capRtnNamespace = AcpProtocol.CapRtnNamespace
	debug.log("info", "listening on CAP RTN namespace (SignalR topic)", {
		namespace = capRtnNamespace,
		via = "NotificationService.RobloxEventReceived + RobloxConnectionChanged"
	})

	local connection = robloxEventReceiver:observeEvent(capRtnNamespace, function(p3, p4, p5)
		local v7 = p2
		local v8 = typeof(p3) == "EnumItem" and p3.EnumType == Enum.ConnectionState

		if v8 then
			debug.log("info", "CAP RTN connection state", {
				namespace = AcpProtocol.CapRtnNamespace,
				connectionState = tostring(p3),
				sequenceNumber = p4,
				seqByNamespace = p5
			})
		else
			onCapEvent(v7, p3, p4)
		end
	end)

	local connection2 = robloxEventReceiver:observeEvent("signalR", function(p3, p4, p5)
		local v7 = typeof(p3) == "EnumItem" and p3.EnumType == Enum.ConnectionState

		if v7 then
			onSignalRConnectionState(p3, p4, p5)
		end
	end)

	return function()
		connection:Disconnect()
		connection2:Disconnect()
	end
end

local function wireCapDelivery(p2)
	if robloxEventReceiver == nil then
		robloxEventReceiver = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
	end

	v5 += 1

	if v6 == nil then
		count = 0
		v6 = subscribeCapNamespace(p2)
		debug.log("info", "CAP RTN listener active — waiting for SignalR posts", {
			namespace = AcpProtocol.CapRtnNamespace
		})
	end

	return function()
		v5 -= 1

		if v5 <= 0 and v6 then
			v6()
			v6 = nil
			v5 = 0
			debug.log("info", "CAP RTN listener stopped", {
				namespace = AcpProtocol.CapRtnNamespace,
				framesReceivedCount = count
			})
		end
	end
end

return wireCapDelivery
