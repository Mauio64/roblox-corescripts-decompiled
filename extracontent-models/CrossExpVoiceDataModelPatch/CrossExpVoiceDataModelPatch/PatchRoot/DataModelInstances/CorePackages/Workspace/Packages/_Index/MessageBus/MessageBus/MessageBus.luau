local MessageBusService = game:GetService("MessageBusService")

require(script.Parent.MessageBusTypes)

local defineFastFlag = game:DefineFastFlag("DisableMessageBusUnSubscribeError", false)

local defineFastFlag2 = game:DefineFastFlag("EnableMessageBusUnSubscribeErrorTelemetry", false)

local MessageBus = {}
MessageBus.__index = MessageBus

function MessageBus.publish(p, p2)
	assert(p.validateParams(p2))
	MessageBusService:Publish(p.mid, p2)
end

function MessageBus.publishProtocolMethodRequest(data, p, p2)
	assert(data.validateParams(p))
	MessageBusService:PublishProtocolMethodRequest(data.protocolName, data.methodName, p, p2)
end

function MessageBus.publishProtocolMethodResponse(data, p, p2: number, p3)
	assert(data.validateParams(p))
	MessageBusService:PublishProtocolMethodResponse(data.protocolName, data.methodName, p, p2, p3)
end

function MessageBus.getLast(p)
	local last = MessageBusService:GetLast(p.mid)

	if last == nil then
		return nil
	end

	assert(p.validateParams(last))
	return last
end

function MessageBus.getMessageId(p: string, p2: string)
	return MessageBusService:GetMessageId(p, p2)
end

function MessageBus.getProtocolMethodRequestMessageId(p: string, p2: string)
	return MessageBusService:GetProtocolMethodRequestMessageId(p, p2)
end

function MessageBus.getProtocolMethodResponseMessageId(p: string, p2: string)
	return MessageBusService:GetProtocolMethodResponseMessageId(p, p2)
end

function MessageBus.call(p, p2)
	assert(p.validateParams(p2))
	return MessageBusService:Call(p.fid, p2)
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({ connections = {} }, class))
end

function class.getSubscriptionCount(p)
	local count = 0

	for _ in pairs(p.connections) do
		count += 1
	end

	return count
end

function class:subscribe(p, callback, flag: boolean?, flag2: boolean?)
	local v = flag == nil or flag

	if flag2 == nil then
		flag2 = false
	end

	local mid = p.mid

	if self.connections[mid] ~= nil then
		self:unsubscribe(p)
	end

	local v2 = MessageBusService:Subscribe(mid, callback, flag2, v)
	self.connections[mid] = v2
end

function class:subscribeProtocolMethodRequest(p, callback, flag: boolean?, flag2: boolean?)
	local v = flag == nil or flag

	if flag2 == nil then
		flag2 = false
	end

	local protocolName = p.protocolName
	local methodName = p.methodName
	local protocolMethodRequestMessageId = MessageBus.getProtocolMethodRequestMessageId(protocolName, methodName)

	if self.connections[protocolMethodRequestMessageId] ~= nil then
		self:unsubscribeWithMsgId(protocolMethodRequestMessageId)
	end

	local v2 = MessageBusService:SubscribeToProtocolMethodRequest(protocolName, methodName, callback, flag2, v)
	self.connections[protocolMethodRequestMessageId] = v2
end

function class:subscribeProtocolMethodResponse(p, callback, flag: boolean?, flag2: boolean?)
	local v = flag == nil or flag

	if flag2 == nil then
		flag2 = false
	end

	local protocolName = p.protocolName
	local methodName = p.methodName
	local protocolMethodResponseMessageId = MessageBus.getProtocolMethodResponseMessageId(protocolName, methodName)

	if self.connections[protocolMethodResponseMessageId] ~= nil then
		self:unsubscribeWithMsgId(protocolMethodResponseMessageId)
	end

	local v2 = MessageBusService:SubscribeToProtocolMethodResponse(protocolName, methodName, callback, flag2, v)
	self.connections[protocolMethodResponseMessageId] = v2
end

function class:unsubscribeToProtocolMethodRequest(p)
	self:unsubscribeWithMsgId(MessageBusService:GetProtocolMethodRequestMessageId(p.protocolName, p.methodName))
end

function class:unsubscribeToProtocolMethodResponse(p)
	self:unsubscribeWithMsgId(MessageBusService:GetProtocolMethodResponseMessageId(p.protocolName, p.methodName))
end

function class:unsubscribe(p)
	self:unsubscribeWithMsgId(p.mid)
end

function class:unsubscribeWithMsgId(p: string)
	local connection = self.connections[p]

	if connection == nil then
		if defineFastFlag then
			if defineFastFlag2 then
				MessageBusService:Call("Telemetry.logEventFromLua", {
					eventType = "RobloxTelemetry",
					config = {
						eventName = "MessageBusErrorEvent",
						backends = { "Points" },
						throttlingPercentage = 10000,
						lastUpdated = { 24, 11, 20 },
						description = "Report MessageBus errors to Points\"",
						links = ""
					},
					data = {
						standardizedFields = nil,
						customFields = {
							err = "unsubscribing from a message id not subscribed to: " .. p
						},
						eventContext = nil
					}
				})
			end

			return
		end

		error("unsubscribing from a message id not subscribed to: " .. p)
	end

	self.connections[p] = nil
	connection:Disconnect()
end

function class.unsubscribeFromAllMessages(p)
	for k, connection in pairs(p.connections) do
		p.connections[k] = nil
		connection:Disconnect()
	end
end

MessageBus.Subscriber = class

return MessageBus
