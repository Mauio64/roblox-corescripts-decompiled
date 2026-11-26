local module = require("@luauforge/bundled/gWB")

local module2 = require("@luauforge/bundled/gWC")
require("@luauforge/bundled/gWD")
require("@luauforge/bundled/gWE")

local MessageBusService = game:GetService("MessageBusService")

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.isAvailable(p2)
	return (module.new(function(callback, p3)
		MessageBusService:MakeRequest(module2.NAME, module2.METHOD_IS_AVAILABLE, {}, function(p4)
			callback(p4.available)
		end, {})
	end))
end

function class.listNativeProducts(p2)
	return (module.new(function(callback, p3)
		MessageBusService:MakeRequest(module2.NAME, module2.METHOD_LIST_NATIVE_PRODUCTS, {}, function(p4)
			callback(p4)
		end, {})
	end))
end

function class.processPendingPurchase(p2)
	MessageBusService:Publish(module2.MESSAGE_PROCESS_PENDING_PURCHASE, {})
end

function class.sendIAPEvent(p2, p3)
	MessageBusService:Publish(module2.MESSAGE_SEND_IAP_EVENT, { eventType = p3 })
end

class.default = class.new()

return class
