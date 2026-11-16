local NotificationService = game:GetService("NotificationService")

local parent = script:FindFirstAncestor("DataHydration").Parent

local RealtimeDelivery = require(parent.RealtimeDelivery)

local AcpProtocol = require(script.Parent.AcpProtocol)
local Debug = require(script.Parent.Parent.debug)
local parseFrame = require(script.Parent.parseFrame)
require(script.Parent.Parent.types)

local robloxEventReceiver = nil
local v = 0
local v2 = nil
local count = 0

local function isConnectionState(p): boolean -- 2 equivalent calls inferred from this helper
	return typeof(p) == "EnumItem" and p.EnumType == Enum.ConnectionState
end

local function previewString(value: string) -- 3 equivalent calls inferred from this helper
	if #value <= 4000 then
		return value
	end

	return string.sub(value, 1, 4000) .. "…"
end

local function summarizeDetail(preview, detailType)
	if typeof(preview) == "string" then
		local v3 = {
			shape = "string",
			length = #preview,
			preview = 0,
			detailType = 0
		}
		preview = previewString(preview) -- inferred equivalent call
		v3.preview = preview
		v3.detailType = detailType
		return v3
	else
		if typeof(preview) ~= "table" then
			return { shape = typeof(preview), value = tostring(preview), detailType = detailType }
		end

		local keys = {}

		for k in preview do
			table.insert(keys, k)
		end

		table.sort(keys)

		return { shape = "table", keys = keys, detailType = detailType }
	end
end

local function extractRawFrame(value)
	if typeof(value) == "string" then
		return value
	end

	if typeof(value) ~= "table" then
		return nil
	end

	for _, v3 in { "frame", "payload", "message", "data", "body" } do
		local v4 = value[v3]

		if typeof(v4) == "string" and v4 ~= "" then
			return v4
		end
	end

	return nil
end

local function extractRtnSequenceNumber(p) -- 2 equivalent calls inferred from this helper
	return if typeof(p) == "table" then p.sequence_number else nil
end

local function describeParsedFrame(data)
	if typeof(data) ~= "table" then
		return { kind = "unknown" }
	end

	if data.kind == "notification" and typeof(data.notification) == "table" then
		local v3 = { kind = "notification", method = data.notification.method }

		local params = data.notification.params

		if typeof(params) ~= "table" then
			return v3
		end

		v3.sessionId = params.sessionId
		local update = params.update

		if typeof(update) ~= "table" then
			return v3
		end

		if typeof(update.sessionUpdate) == "string" then
			v3.sessionUpdate = update.sessionUpdate
		end

		if update.sessionUpdate == "state_change" then
			v3.state = update.state
			v3.stopReason = update.stop_reason
		end

		return v3
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

local function onCapConnectionState(p, sequenceNumber, seqByNamespace) -- 1 equivalent call inferred from this helper
	Debug.log("info", "CAP RTN connection state", {
		namespace = AcpProtocol.CapRtnNamespace,
		connectionState = tostring(p),
		sequenceNumber = sequenceNumber,
		seqByNamespace = seqByNamespace
	})
end

local function onSignalRConnectionState(p, sequenceNumber, p2)
	local capSequenceNumber

	if typeof(p2) == "table" then
		capSequenceNumber = p2[AcpProtocol.CapRtnNamespace]
	end

	Debug.log("info", "SignalR connection state", {
		connectionState = tostring(p),
		sequenceNumber = sequenceNumber,
		capNamespace = AcpProtocol.CapRtnNamespace,
		capSequenceNumber = capSequenceNumber
	})
end

local function onCapEvent(p, p2, detailType)
	count += 1
	local messageIndex = count

	Debug.log("info", "CAP RTN message received", {
		namespace = AcpProtocol.CapRtnNamespace,
		messageIndex = messageIndex,
		sequenceNumber = extractRtnSequenceNumber(p2), -- inferred equivalent call
		summary = summarizeDetail(p2, detailType)
	})

	local preview = extractRawFrame(p2)

	if preview == nil then
		Debug.log("warn", "CAP RTN message has no parseable frame field", {
			namespace = AcpProtocol.CapRtnNamespace,
			messageIndex = messageIndex,
			summary = summarizeDetail(p2, detailType),
			hint = "Expected string body or table key frame|payload|message|data|body"
		})

		return
	end

	Debug.log("info", "CAP RTN raw frame", {
		namespace = AcpProtocol.CapRtnNamespace,
		messageIndex = messageIndex,
		length = #preview,
		preview = previewString(preview) -- inferred equivalent call
	})

	local v3 = parseFrame(preview)

	if v3 == nil then
		local log = Debug.log
		local v4 = {
			messageIndex = messageIndex,
			preview = 0,
			hint = "Expected JSON-RPC notification or response"
		}
		preview = previewString(preview) -- inferred equivalent call
		v4.preview = preview
		log("warn", "CAP frame dropped (parseFrame returned nil)", v4)
	else
		local parsed = describeParsedFrame(v3)
		Debug.log("info", "CAP frame ingested", { messageIndex = messageIndex, parsed = parsed })

		p.ingestFrame(v3, { sequenceNumber = extractRtnSequenceNumber(p2) }) -- inferred equivalent call

		if v3.kind == "response" then
			Debug.log("info", "CAP response ingested", {
				messageIndex = messageIndex,
				parsed = parsed
			})

			return
		end

		local sessionId = parsed.sessionId
		local function logTurnSnapshot(p3: string)
			if typeof(sessionId) ~= "string" then
				return
			end

			local activeTurnHandle = p.getActiveTurnHandle(sessionId)

			if activeTurnHandle == nil then
				return
			end

			Debug.log("info", p3, {
				messageIndex = messageIndex,
				turn = Debug.formatTurnState(activeTurnHandle.state(false))
			})
		end

		if parsed.sessionUpdate == "agent_message_chunk" or parsed.sessionUpdate == "state_change" then
			logTurnSnapshot(`CAP turn state after {parsed.sessionUpdate}`)
		end
	end
end

local function onNamespaceSignal(p, p2, sequenceNumber, seqByNamespace) -- 1 equivalent call inferred from this helper
	if isConnectionState(p2) then -- inferred equivalent call
		onCapConnectionState(p2, sequenceNumber, seqByNamespace) -- inferred equivalent call
	else
		onCapEvent(p, p2, sequenceNumber)
	end
end

local function ensureReceiver() -- 1 equivalent call inferred from this helper
	if robloxEventReceiver == nil then
		robloxEventReceiver = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
	end
end

local function subscribeCapNamespace(p)
	local capRtnNamespace = AcpProtocol.CapRtnNamespace
	Debug.log("info", "listening on CAP RTN namespace (SignalR topic)", {
		namespace = capRtnNamespace,
		via = "NotificationService.RobloxEventReceived + RobloxConnectionChanged"
	})

	local connection = robloxEventReceiver:observeEvent(capRtnNamespace, function(p2, sequenceNumber, seqByNamespace)
		onNamespaceSignal(p, p2, sequenceNumber, seqByNamespace) -- inferred equivalent call
	end)

	local connection2 = robloxEventReceiver:observeEvent("signalR", function(p2, sequenceNumber, p3)
		if isConnectionState(p2) then -- inferred equivalent call
			onSignalRConnectionState(p2, sequenceNumber, p3)
		end
	end)

	return function()
		connection:Disconnect()
		connection2:Disconnect()
	end
end

local function wireCapDelivery(p)
	ensureReceiver() -- inferred equivalent call
	v += 1

	if v2 == nil then
		count = 0
		v2 = subscribeCapNamespace(p)
		Debug.log("info", "CAP RTN listener active — waiting for SignalR posts", {
			namespace = AcpProtocol.CapRtnNamespace
		})
	end

	return function()
		v -= 1

		if v <= 0 and v2 then
			v2()
			v2 = nil
			v = 0
			Debug.log("info", "CAP RTN listener stopped", {
				namespace = AcpProtocol.CapRtnNamespace,
				framesReceivedCount = count
			})
		end
	end
end

return wireCapDelivery
