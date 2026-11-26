local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/Logger")

local v5 = {}

local function logListenerError(p2)
	Logger:error("DeeplinkTapListeners: a listener failed: {}", (tostring(p2)))
end

return {
	connect = function(p2)
		local v6 = { listener = p2, connected = true }
		table.insert(v5, v6)
		return function()
			if not v6.connected then
				return
			end

			v6.connected = false
			local index = table.find(v5, v6)

			if index then
				table.remove(v5, index)
			end
		end
	end,
	notify = function(p2)
		for k, v6 in table.clone(v5) do
			if v6.connected then
				xpcall(v6.listener, logListenerError, p2)
			end
		end
	end
}
