local messageBus = require("@luauforge/bundled/ggr").MessageBus

local selfViewVisibilityUpdatedSignal = require("@game/CoreGui/RobloxGui/Modules/SelfView/selfViewVisibilityUpdatedSignal")

local class = {}
class.__index = class

function class.onLaunched(p2, p3)
	local messageId = messageBus.getMessageId("Game", "launchSuccess")
	return p2.subscribe(messageId, p3)
end

function class:onLeft(p3)
	local messageId = messageBus.getMessageId("Game", "onGameLeave")
	return self.subscribe(messageId, p3)
end

function class:UnsubscribeFromAllMessages()
	self.subscriber:unsubscribeFromAllMessages()
end

function class.new()
	local v5 = { signalTable = {}, subscriber = messageBus.Subscriber.new() }

	function v5.subscribe(p2, callback)
		assert(type(callback) == "function", "Expected callback to be a function")

		local v6 = v5.signalTable[p2]

		if v6 == nil then
			v6 = selfViewVisibilityUpdatedSignal.new()
			v5.signalTable[p2] = v6
			v5.subscriber:subscribe({ mid = p2 }, function(p3)
				v6:fire(p3)
			end)
		end

		return v6:connect(callback)
	end

	setmetatable(v5, class)
	return v5
end

return class
