local NotificationsCommon = script:FindFirstAncestor("NotificationsCommon")
local Logger = require(NotificationsCommon.Logger)

local v = {}

local function logListenerError(p)
	Logger:error("DeeplinkTapListeners: a listener failed: {}", (tostring(p)))
end

local DeeplinkTapListeners = {}

function DeeplinkTapListeners.connect(listener)
	local v2 = { listener = listener, connected = true }
	table.insert(v, v2)
	return function()
		if not v2.connected then
			return
		end

		v2.connected = false
		local index = table.find(v, v2)

		if index then
			table.remove(v, index)
		end
	end
end

function DeeplinkTapListeners.notify(p)
	for _, v2 in table.clone(v) do
		if v2.connected then
			xpcall(v2.listener, logListenerError, p)
		end
	end
end

return DeeplinkTapListeners
