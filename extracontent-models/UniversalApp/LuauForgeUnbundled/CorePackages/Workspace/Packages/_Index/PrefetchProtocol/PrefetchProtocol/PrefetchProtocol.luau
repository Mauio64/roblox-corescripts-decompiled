local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/PrefetchProtocol/MessageBus").MessageBus
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/PrefetchProtocol/t")

require("@game/CorePackages/Workspace/Packages/_Index/PrefetchProtocol/PrefetchProtocol/PrefetchProtocolTypes")

local v5 = {
	POP_GUID_DESCRIPTOR = {
		fid = messageBus.getMessageId("Prefetch", "popPendingPrefetchGuid"),
		validateParams = t.table
	}
}

v5.__index = v5

function v5.new(p2)
	local v6 = {
		messageBus = p2 or messageBus
	}

	setmetatable(v6, v5)
	return v6
end

function v5:popPendingPrefetchGuid()
	return self.messageBus.call(self.POP_GUID_DESCRIPTOR, {})
end

v5.default = v5.new()

return v5
