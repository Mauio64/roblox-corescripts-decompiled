local MessageBusService = game:GetService("MessageBusService")

require("@game/CorePackages/Workspace/Packages/_Workspace/MessageBus/MessageBus/MessageBusTypes")

local defineFastFlag = game:DefineFastFlag("DisableMessageBusUnSubscribeError", false)

local defineFastFlag2 = game:DefineFastFlag("EnableMessageBusUnSubscribeErrorTelemetry", false)

local v5 = {}
v5.__index = v5

function v5.publish(p2, p3)
	assert(p2.validateParams(p3))
	MessageBusService:Publish(p2.mid, p3)
end

function v5.publishProtocolMethodRequest(data, p2, p3)
	assert(data.validateParams(p2))
	MessageBusService:PublishProtocolMethodRequest(data.protocolName, data.methodName, p2, p3)
end

function v5.publishProtocolMethodResponse(data, p2, p3, p4)
	assert(data.validateParams(p2))
	MessageBusService:PublishProtocolMethodResponse(data.protocolName, data.methodName, p2, p3, p4)
end

function v5.getLast(p2)
	local last = MessageBusService:GetLast(p2.mid)

	if last == nil then
		return nil
	end

	assert(p2.validateParams(last))
	return last
end

function v5.getMessageId(p2, p3)
	return MessageBusService:GetMessageId(p2, p3)
end

function v5.getProtocolMethodRequestMessageId(p2, p3)
	return MessageBusService:GetProtocolMethodRequestMessageId(p2, p3)
end

function v5.getProtocolMethodResponseMessageId(p2, p3)
	return MessageBusService:GetProtocolMethodResponseMessageId(p2, p3)
end

function v5.call(p2, p3)
	assert(p2.validateParams(p3))
	return MessageBusService:Call(p2.fid, p3)
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({ connections = {} }, class))
end

function class.getSubscriptionCount(p2)
	local count = 0

	for k in pairs(p2.connections) do
		count += 1
	end

	return count
end

function class:subscribe(p2, p3, p4, p5)
	local v6 = p4 == nil or p4

	if p5 == nil then
		p5 = false
	end

	local mid = p2.mid

	if self.connections[mid] ~= nil then
		self:unsubscribe(p2)
	end

	local v7 = MessageBusService:Subscribe(mid, p3, p5, v6)
	self.connections[mid] = v7
end

function class:subscribeProtocolMethodRequest(p2, p3, p4, p5)
	local v6 = p4 == nil or p4

	if p5 == nil then
		p5 = false
	end

	local protocolName = p2.protocolName
	local methodName = p2.methodName
	local protocolMethodRequestMessageId = v5.getProtocolMethodRequestMessageId(protocolName, methodName)

	if self.connections[protocolMethodRequestMessageId] ~= nil then
		self:unsubscribeWithMsgId(protocolMethodRequestMessageId)
	end

	local v7 = MessageBusService:SubscribeToProtocolMethodRequest(protocolName, methodName, p3, p5, v6)
	self.connections[protocolMethodRequestMessageId] = v7
end

function class:subscribeProtocolMethodResponse(p2, p3, p4, p5)
	local v6 = p4 == nil or p4

	if p5 == nil then
		p5 = false
	end

	local protocolName = p2.protocolName
	local methodName = p2.methodName
	local protocolMethodResponseMessageId = v5.getProtocolMethodResponseMessageId(protocolName, methodName)

	if self.connections[protocolMethodResponseMessageId] ~= nil then
		self:unsubscribeWithMsgId(protocolMethodResponseMessageId)
	end

	local v7 = MessageBusService:SubscribeToProtocolMethodResponse(protocolName, methodName, p3, p5, v6)
	self.connections[protocolMethodResponseMessageId] = v7
end

function class:unsubscribeToProtocolMethodRequest(p2)
	self:unsubscribeWithMsgId(MessageBusService:GetProtocolMethodRequestMessageId(
		p2.protocolName,
		p2.methodName
	))
end

function class:unsubscribeToProtocolMethodResponse(p2)
	self:unsubscribeWithMsgId(MessageBusService:GetProtocolMethodResponseMessageId(
		p2.protocolName,
		p2.methodName
	))
end

function class:unsubscribe(p2)
	self:unsubscribeWithMsgId(p2.mid)
end

function class:unsubscribeWithMsgId(p3)
	local connection = self.connections[p3]

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
							err = "unsubscribing from a message id not subscribed to: " .. p3
						},
						eventContext = nil
					}
				})
			end

			return
		end

		error("unsubscribing from a message id not subscribed to: " .. p3)
	end

	self.connections[p3] = nil
	connection:Disconnect()
end

function class:unsubscribeFromAllMessages()
	for k, connection in pairs(self.connections) do
		self.connections[k] = nil
		connection:Disconnect()
	end
end

v5.Subscriber = class

return v5
