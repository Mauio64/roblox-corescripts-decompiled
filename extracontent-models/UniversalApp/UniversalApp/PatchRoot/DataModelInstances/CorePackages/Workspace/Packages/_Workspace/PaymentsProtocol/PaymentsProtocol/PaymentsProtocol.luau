local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Promise = require(scriptParentParent.Promise)
local PaymentsProtocolConstants = require(scriptParent.PaymentsProtocolConstants)

require(scriptParent.PaymentsProtocolTypes)
require(scriptParent.Enums.IAPEventType)

local MessageBusService = game:GetService("MessageBusService")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 21
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end
function t1.isAvailable(_) -- line: 29
	-- upvalues: Promise (copy), MessageBusService (copy), PaymentsProtocolConstants (copy)
	return (Promise.new(function(resolve, _) -- line: 30
		-- upvalues: MessageBusService (copy), PaymentsProtocolConstants (copy)
		MessageBusService:MakeRequest(PaymentsProtocolConstants.NAME, PaymentsProtocolConstants.METHOD_IS_AVAILABLE, {}, function(t2: {[any]: any}) -- line: 35
			-- upvalues: resolve (copy)
			resolve(t2.available)
		end, {})
	end))
end
function t1.listNativeProducts(_) -- line: 47
	-- upvalues: Promise (copy), MessageBusService (copy), PaymentsProtocolConstants (copy)
	return (Promise.new(function(resolve, _) -- line: 48
		-- upvalues: MessageBusService (copy), PaymentsProtocolConstants (copy)
		MessageBusService:MakeRequest(PaymentsProtocolConstants.NAME, PaymentsProtocolConstants.METHOD_LIST_NATIVE_PRODUCTS, {}, function(p5) -- line: 53
			-- upvalues: resolve (copy)
			resolve(p5)
		end, {})
	end))
end
function t1.processPendingPurchase(_) -- line: 65
	-- upvalues: MessageBusService (copy), PaymentsProtocolConstants (copy)
	MessageBusService:Publish(PaymentsProtocolConstants.MESSAGE_PROCESS_PENDING_PURCHASE, {})
end
function t1.sendIAPEvent(_, p8) -- line: 72
	-- upvalues: MessageBusService (copy), PaymentsProtocolConstants (copy)
	MessageBusService:Publish(PaymentsProtocolConstants.MESSAGE_SEND_IAP_EVENT, {
		eventType = p8
	})
end

t1.default = t1.new()

return t1
