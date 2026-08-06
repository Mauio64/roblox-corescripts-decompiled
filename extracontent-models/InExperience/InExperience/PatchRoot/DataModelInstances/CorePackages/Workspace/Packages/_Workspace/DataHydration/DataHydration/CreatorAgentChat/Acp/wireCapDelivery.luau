local NotificationService = game:GetService("NotificationService")
local Parent = script:FindFirstAncestor("DataHydration").Parent
local RealtimeDelivery = require(Parent.RealtimeDelivery)
local AcpProtocol = require(script.Parent.AcpProtocol)
local debug = require(script.Parent.Parent.debug)
local parseFrame = require(script.Parent.parseFrame)

require(script.Parent.Parent.types)

local u7 = nil
local n1 = 0
local u9 = nil
local n2 = 0

local function isConnectionState(p1) -- line: 28
	return typeof(p1) == "EnumItem" and p1.EnumType == Enum.ConnectionState
end
local function previewString(s1: string) -- line: 32
	if #s1 <= 4000 then
		return s1
	end

	return string.sub(s1, 1, 4000) .. "…"
end
local function summarizeDetail(p2, p3) -- line: 39
	if typeof(p2) == "string" then
		return {
			shape = "string",
			length = #p2,
			preview = if not (#p2 <= 4000) then string.sub(p2, 1, 4000) .. "…" else p2,
			detailType = p3
		}
	end

	if typeof(p2) ~= "table" then
		return {
			shape = typeof(p2),
			value = tostring(p2),
			detailType = p3
		}
	end

	local t1 = {}

	for v29 in p2 do
		table.insert(t1, v29)
	end

	table.sort(t1)

	return {
		shape = "table",
		keys = t1,
		detailType = p3
	}
end
local function extractRawFrame(p4) -- line: 69
	if typeof(p4) == "string" then
		return p4
	end

	if typeof(p4) ~= "table" then
		return nil
	end

	for _, v32 in {
		"frame",
		"payload",
		"message",
		"data",
		"body"
	} do
		local v33 = p4[v32]

		if typeof(v33) == "string" and v33 ~= "" then
			return v33
		end
	end

	return nil
end
local function extractRtnSequenceNumber(p5) -- line: 85
	if typeof(p5) ~= "table" then
		return nil
	end

	return p5.sequence_number
end
local function describeParsedFrame(p6) -- line: 92
	if typeof(p6) ~= "table" then
		return {
			kind = "unknown"
		}
	end

	if p6.kind == "notification" and typeof(p6.notification) == "table" then
		local t2 = {
			kind = "notification",
			method = p6.notification.method
		}
		local params = p6.notification.params

		if typeof(params) == "table" then
			t2.sessionId = params.sessionId

			local update = params.update

			if typeof(update) == "table" then
				if typeof(update.sessionUpdate) == "string" then
					t2.sessionUpdate = update.sessionUpdate
				end

				if update.sessionUpdate == "state_change" then
					t2.state = update.state
					t2.stopReason = update.stop_reason
				end
			end
		end

		return t2
	end

	if p6.kind == "response" and typeof(p6.response) == "table" then
		return {
			kind = "response",
			id = p6.response.id,
			hasError = typeof(p6.response.error) == "table"
		}
	end

	return {
		kind = p6.kind
	}
end
local function onCapConnectionState(p7, p8, p9) -- line: 128
	-- upvalues: debug (copy), AcpProtocol (copy)
	debug.log("info", "CAP RTN connection state", {
		namespace = AcpProtocol.CapRtnNamespace,
		connectionState = tostring(p7),
		sequenceNumber = p8,
		seqByNamespace = p9
	})
end
local function onSignalRConnectionState(p10, p11, p12) -- line: 137
	-- upvalues: AcpProtocol (copy), debug (copy)
	local v45 = if typeof(p12) ~= "table" then nil else p12[AcpProtocol.CapRtnNamespace]

	debug.log("info", "SignalR connection state", {
		connectionState = tostring(p10),
		sequenceNumber = p11,
		capNamespace = AcpProtocol.CapRtnNamespace,
		capSequenceNumber = v45
	})
end
local function onCapEvent(p13, p14, p15) -- line: 151
	-- upvalues: n2 (ref), debug (copy), AcpProtocol (copy), summarizeDetail (copy), extractRawFrame (copy), parseFrame (copy), describeParsedFrame (copy)
	n2 += 1

	local v49 = n2

	debug.log("info", "CAP RTN message received", {
		namespace = AcpProtocol.CapRtnNamespace,
		messageIndex = v49,
		sequenceNumber = if typeof(p14) == "table" then p14.sequence_number else nil,
		summary = summarizeDetail(p14, p15)
	})

	local v50 = extractRawFrame(p14)

	if v50 == nil then
		debug.log("warn", "CAP RTN message has no parseable frame field", {
			hint = "Expected string body or table key frame|payload|message|data|body",
			namespace = AcpProtocol.CapRtnNamespace,
			messageIndex = v49,
			summary = summarizeDetail(p14, p15)
		})

		return
	end

	debug.log("info", "CAP RTN raw frame", {
		namespace = AcpProtocol.CapRtnNamespace,
		messageIndex = v49,
		length = #v50,
		preview = if not (#v50 <= 4000) then string.sub(v50, 1, 4000) .. "…" else v50
	})

	local v51 = parseFrame(v50)

	if v51 == nil then
		debug.log("warn", "CAP frame dropped (parseFrame returned nil)", {
			hint = "Expected JSON-RPC notification or response",
			messageIndex = v49,
			preview = if not (#v50 <= 4000) then string.sub(v50, 1, 4000) .. "…" else v50
		})

		return
	end

	local v52 = describeParsedFrame(v51)

	debug.log("info", "CAP frame ingested", {
		messageIndex = v49,
		parsed = v52
	})
	p13.ingestFrame(v51, {
		sequenceNumber = if typeof(p14) == "table" then p14.sequence_number else nil
	})

	if v51.kind == "response" then
		debug.log("info", "CAP response ingested", {
			messageIndex = v49,
			parsed = v52
		})

		return
	end

	local sessionId = v52.sessionId

	local function logTurnSnapshot(s2: string) -- line: 210
		-- upvalues: sessionId (copy), p13 (copy), debug (copy), v49 (copy)
		if typeof(sessionId) ~= "string" then
			return
		end

		local v65 = p13.getActiveTurnHandle(sessionId)

		if v65 == nil then
			return
		end

		debug.log("info", s2, {
			messageIndex = v49,
			turn = debug.formatTurnState(v65.state(false))
		})
	end

	if v52.sessionUpdate == "agent_message_chunk" or v52.sessionUpdate == "state_change" then
		logTurnSnapshot(`CAP turn state after { v52.sessionUpdate }`)
	end
end
local function onNamespaceSignal(p16, p17, p18, p19) -- line: 229
	-- upvalues: debug (copy), AcpProtocol (copy), onCapEvent (copy)
	if typeof(p17) == "EnumItem" and p17.EnumType == Enum.ConnectionState then
		debug.log("info", "CAP RTN connection state", {
			namespace = AcpProtocol.CapRtnNamespace,
			connectionState = tostring(p17),
			sequenceNumber = p18,
			seqByNamespace = p19
		})

		return
	end

	onCapEvent(p16, p17, p18)
end
local function ensureReceiver() -- line: 238
	-- upvalues: u7 (ref), RealtimeDelivery (copy), NotificationService (copy)
	if u7 == nil then
		u7 = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
	end
end
local function subscribeCapNamespace(p20) -- line: 244
	-- upvalues: AcpProtocol (copy), debug (copy), u7 (ref), onCapEvent (copy), onSignalRConnectionState (copy)
	local CapRtnNamespace = AcpProtocol.CapRtnNamespace

	debug.log("info", "listening on CAP RTN namespace (SignalR topic)", {
		via = "NotificationService.RobloxEventReceived + RobloxConnectionChanged",
		namespace = CapRtnNamespace
	})

	local v61 = u7:observeEvent(CapRtnNamespace, function(p21, p22, p23) -- line: 251
		-- upvalues: p20 (copy), debug (copy), AcpProtocol (copy), onCapEvent (copy)
		local v69 = p20

		if typeof(p21) == "EnumItem" and p21.EnumType == Enum.ConnectionState then
			debug.log("info", "CAP RTN connection state", {
				namespace = AcpProtocol.CapRtnNamespace,
				connectionState = tostring(p21),
				sequenceNumber = p22,
				seqByNamespace = p23
			})

			return
		end

		onCapEvent(v69, p21, p22)
	end)
	local v62 = u7:observeEvent("signalR", function(p24, p25, p26) -- line: 257
		-- upvalues: onSignalRConnectionState (copy)
		if typeof(p24) == "EnumItem" and p24.EnumType == Enum.ConnectionState then
			onSignalRConnectionState(p24, p25, p26)
		end
	end)

	return function() -- line: 264
		-- upvalues: v61 (copy), v62 (copy)
		v61:Disconnect()
		v62:Disconnect()
	end
end
local function wireCapDelivery(p27) -- line: 270
	-- upvalues: u7 (ref), RealtimeDelivery (copy), NotificationService (copy), n1 (ref), u9 (ref), n2 (ref), subscribeCapNamespace (copy), debug (copy), AcpProtocol (copy)
	if u7 == nil then
		u7 = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
	end

	n1 += 1

	if u9 == nil then
		n2 = 0
		u9 = subscribeCapNamespace(p27)
		debug.log("info", "CAP RTN listener active — waiting for SignalR posts", {
			namespace = AcpProtocol.CapRtnNamespace
		})
	end

	return function() -- line: 282
		-- upvalues: n1 (ref), u9 (ref), debug (copy), AcpProtocol (copy), n2 (ref)
		n1 -= 1

		if n1 <= 0 and u9 then
			u9()
			u9 = nil
			n1 = 0
			debug.log("info", "CAP RTN listener stopped", {
				namespace = AcpProtocol.CapRtnNamespace,
				framesReceivedCount = n2
			})
		end
	end
end

return wireCapDelivery
