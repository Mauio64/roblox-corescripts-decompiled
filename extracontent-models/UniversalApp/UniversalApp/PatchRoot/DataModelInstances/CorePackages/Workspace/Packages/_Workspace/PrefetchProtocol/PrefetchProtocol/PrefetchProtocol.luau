local ParentParent = script.Parent.Parent
local MessageBus = require(ParentParent.MessageBus).MessageBus
local t = require(ParentParent.t)

require(script.Parent.PrefetchProtocolTypes)

local t1 = {
	POP_GUID_DESCRIPTOR = {
		fid = MessageBus.getMessageId("Prefetch", "popPendingPrefetchGuid"),
		validateParams = t.table
	}
}

t1.__index = t1

function t1.new(p1) -- line: 31
	-- upvalues: MessageBus (copy), t1 (copy)
	local t2 = {
		messageBus = p1 or MessageBus
	}

	setmetatable(t2, t1)

	return t2
end
function t1.popPendingPrefetchGuid(p2) -- line: 39
	return p2.messageBus.call(p2.POP_GUID_DESCRIPTOR, {})
end

t1.default = t1.new()

return t1
