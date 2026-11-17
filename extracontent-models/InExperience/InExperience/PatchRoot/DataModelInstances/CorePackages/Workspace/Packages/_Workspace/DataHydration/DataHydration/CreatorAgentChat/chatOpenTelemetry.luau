local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local signal, v = Signals.createSignal(nil)

local function updateOpenChat(chatOpenId: string, universeId: number?, sessionId: string?)
	local v2 = signal(false)

	if v2 ~= nil and v2.chatOpenId == chatOpenId and (v2.universeId ~= universeId or v2.sessionId ~= sessionId) then
		v(table.freeze({ chatOpenId = chatOpenId, universeId = universeId, sessionId = sessionId }))
	end
end

local ChatOpenTelemetry = {}

function ChatOpenTelemetry.open(chatOpenId: string, universeId: number?)
	local v2 = signal(false)

	if v2 == nil or v2.chatOpenId ~= chatOpenId then
		v(table.freeze({ chatOpenId = chatOpenId, universeId = universeId }))
	end
end

function ChatOpenTelemetry.close(p: string)
	local v2 = signal(false)

	if v2 ~= nil and v2.chatOpenId == p then
		v(nil)
	end
end

function ChatOpenTelemetry.setUniverseId(chatOpenId: string, universeId: number?)
	local v2 = signal(false)
	local v3

	if v2 ~= nil then
		v3 = v2.sessionId
	end

	updateOpenChat(chatOpenId, universeId, v3)
end

function ChatOpenTelemetry.setSessionId(chatOpenId: string, sessionId: string?)
	local v2 = signal(false)
	local v3

	if v2 ~= nil then
		v3 = v2.universeId
	end

	updateOpenChat(chatOpenId, v3, sessionId)
end

function ChatOpenTelemetry.getChatOpenId()
	local v2 = signal(false)
	return if v2 ~= nil then v2.chatOpenId else nil
end

function ChatOpenTelemetry.getSessionId()
	local v2 = signal(false)
	return if v2 ~= nil then v2.sessionId else nil
end

function ChatOpenTelemetry.getChatOpenIdForUniverse(p: number?)
	local v2 = signal(false)

	if v2 == nil or v2.universeId ~= p then
		return nil
	end

	return v2.chatOpenId
end

function ChatOpenTelemetry.resolveEventIds(p: string?, p2: string?, p3: number?)
	local v2 = signal(false)

	if v2 == nil then
		return p, nil
	end

	local v3

	if p == nil then
		if p2 == nil then
			if p3 == nil then
				v3 = v2.universeId == nil
			else
				v3 = p3 == v2.universeId
			end
		else
			v3 = p2 == v2.sessionId
		end
	else
		v3 = p == v2.chatOpenId
	end

	if v3 then
		return v2.chatOpenId, v2.sessionId
	end

	return p, nil
end

return ChatOpenTelemetry
