local MessageBusService = game:GetService("MessageBusService")

require(script.Parent.MessageBusTypes)

local v2 = game:DefineFastFlag("DisableMessageBusUnSubscribeError", false)
local v3 = game:DefineFastFlag("EnableMessageBusUnSubscribeErrorTelemetry", false)
local t1 = {}

t1.__index = t1

function t1.publish(p1, p2) -- line: 41
	-- upvalues: MessageBusService (copy)
	assert(p1.validateParams(p2))
	MessageBusService:Publish(p1.mid, p2)
end
function t1.publishProtocolMethodRequest(p3, p4, p5) -- line: 46
	-- upvalues: MessageBusService (copy)
	assert(p3.validateParams(p4))
	MessageBusService:PublishProtocolMethodRequest(p3.protocolName, p3.methodName, p4, p5)
end
function t1.publishProtocolMethodResponse(p6, p7, n1: number, p8) -- line: 55
	-- upvalues: MessageBusService (copy)
	assert(p6.validateParams(p7))
	MessageBusService:PublishProtocolMethodResponse(p6.protocolName, p6.methodName, p7, n1, p8)
end
function t1.getLast(p9) -- line: 71
	-- upvalues: MessageBusService (copy)
	local Last = MessageBusService:GetLast(p9.mid)

	if Last == nil then
		return nil
	end

	assert(p9.validateParams(Last))

	return Last
end
function t1.getMessageId(s1: string, s2: string) -- line: 80
	-- upvalues: MessageBusService (copy)
	return MessageBusService:GetMessageId(s1, s2)
end
function t1.getProtocolMethodRequestMessageId(s3: string, s4: string) -- line: 84
	-- upvalues: MessageBusService (copy)
	return MessageBusService:GetProtocolMethodRequestMessageId(s3, s4)
end
function t1.getProtocolMethodResponseMessageId(s5: string, s6: string) -- line: 88
	-- upvalues: MessageBusService (copy)
	return MessageBusService:GetProtocolMethodResponseMessageId(s5, s6)
end
function t1.call(p10, p11) -- line: 92
	-- upvalues: MessageBusService (copy)
	assert(p10.validateParams(p11))

	return MessageBusService:Call(p10.fid, p11)
end

local t2 = {}

t2.__index = t2

function t2.new() -- line: 100
	-- upvalues: t2 (copy)
	return (setmetatable({
		connections = {}
	}, t2))
end
function t2.getSubscriptionCount(p12) -- line: 107
	local n2 = 0

	for _ in pairs(p12.connections) do
		n2 += 1
	end

	return n2
end
function t2.subscribe(t3: {[any]: any}, p13, p14: ((...any) -> ...any), b1: boolean?, b2: boolean?) -- line: 115
	-- upvalues: MessageBusService (copy)
	local v33 = b1 == nil or b1
	local v34 = b2 ~= nil and b2
	local mid = p13.mid

	if t3.connections[mid] ~= nil then
		t3:unsubscribe(p13)
	end

	local v36 = MessageBusService:Subscribe(mid, p14, v34, v33)

	t3.connections[mid] = v36
end
function t2.subscribeProtocolMethodRequest(t4: {[any]: any}, p15, p16: ((...any) -> ...any), b3: boolean?, b4: boolean?) -- line: 128
	-- upvalues: t1 (copy), MessageBusService (copy)
	local v42 = b3 == nil or b3
	local v43 = b4 ~= nil and b4
	local protocolName = p15.protocolName
	local methodName = p15.methodName
	local v46 = t1.getProtocolMethodRequestMessageId(protocolName, methodName)

	if t4.connections[v46] ~= nil then
		t4:unsubscribeWithMsgId(v46)
	end

	local v47 = MessageBusService:SubscribeToProtocolMethodRequest(protocolName, methodName, p16, v43, v42)

	t4.connections[v46] = v47
end
function t2.subscribeProtocolMethodResponse(t5: {[any]: any}, p17, p18: ((...any) -> ...any), b5: boolean?, b6: boolean?) -- line: 148
	-- upvalues: t1 (copy), MessageBusService (copy)
	local v53 = b5 == nil or b5
	local v54 = b6 ~= nil and b6
	local protocolName = p17.protocolName
	local methodName = p17.methodName
	local v57 = t1.getProtocolMethodResponseMessageId(protocolName, methodName)

	if t5.connections[v57] ~= nil then
		t5:unsubscribeWithMsgId(v57)
	end

	local v58 = MessageBusService:SubscribeToProtocolMethodResponse(protocolName, methodName, p18, v54, v53)

	t5.connections[v57] = v58
end
function t2.unsubscribeToProtocolMethodRequest(p19, p20) -- line: 168
	-- upvalues: MessageBusService (copy)
	p19:unsubscribeWithMsgId(MessageBusService:GetProtocolMethodRequestMessageId(p20.protocolName, p20.methodName))
end
function t2.unsubscribeToProtocolMethodResponse(p21, p22) -- line: 172
	-- upvalues: MessageBusService (copy)
	p21:unsubscribeWithMsgId(MessageBusService:GetProtocolMethodResponseMessageId(p22.protocolName, p22.methodName))
end
function t2.unsubscribe(p23, p24) -- line: 176
	p23:unsubscribeWithMsgId(p24.mid)
end
function t2.unsubscribeWithMsgId(t6: {[any]: any}, s7: string) -- line: 180
	-- upvalues: v2 (copy), v3 (copy), MessageBusService (copy)
	local v67 = t6.connections[s7]

	if v67 == nil then
		if v2 then
			if v3 then
				local t7 = {
					err = "unsubscribing from a message id not subscribed to: " .. s7
				}
				local t8 = {
					eventType = "RobloxTelemetry",
					config = {
						eventName = "MessageBusErrorEvent",
						throttlingPercentage = 10000,
						description = "Report MessageBus errors to Points\"",
						links = "",
						backends = { "Points" },
						lastUpdated = {
							24,
							11,
							20
						}
					},
					data = {
						standardizedFields = nil,
						eventContext = nil,
						customFields = t7
					}
				}

				MessageBusService:Call("Telemetry.logEventFromLua", t8)
			end

			return
		end

		error("unsubscribing from a message id not subscribed to: " .. s7)
	end

	t6.connections[s7] = nil
	v67:Disconnect()
end
function t2.unsubscribeFromAllMessages(p25) -- line: 223
	for k, v in pairs(p25.connections) do
		p25.connections[k] = nil
		v:Disconnect()
	end
end

t1.Subscriber = t2

return t1
