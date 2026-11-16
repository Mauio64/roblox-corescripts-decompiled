local parent = script.Parent.Parent
local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local t = require(parent.t)

require(script.Parent.PrefetchProtocolTypes)

local PrefetchProtocol = {
	POP_GUID_DESCRIPTOR = {
		fid = messageBus.getMessageId("Prefetch", "popPendingPrefetchGuid"),
		validateParams = t.table
	}
}

PrefetchProtocol.__index = PrefetchProtocol

function PrefetchProtocol.new(p)
	local v = {
		messageBus = p or messageBus
	}

	setmetatable(v, PrefetchProtocol)
	return v
end

function PrefetchProtocol.popPendingPrefetchGuid(p)
	return p.messageBus.call(p.POP_GUID_DESCRIPTOR, {})
end

PrefetchProtocol.default = PrefetchProtocol.new()

return PrefetchProtocol
