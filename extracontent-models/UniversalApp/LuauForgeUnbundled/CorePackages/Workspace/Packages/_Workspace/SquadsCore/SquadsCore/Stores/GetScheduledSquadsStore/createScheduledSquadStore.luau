local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")

local createComputed = Signals.createComputed

local getSubscribedScheduledSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/NetworkRequests").getSubscribedScheduledSquads
local getScheduledSquadStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/NetworkRequests").getScheduledSquadStatus
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types")

return function()
	local signal, v5 = Signals.createSignal({})

	local signal2, v6 = Signals.createSignal({})

	return {
		getSubscribedScheduledSquads = createComputed(function(p2)
			return signal(p2)
		end),
		getScheduledSquadsStatus = createComputed(function(p2)
			return signal2(p2)
		end),
		fetchSubscribedScheduledSquads = function()
			getSubscribedScheduledSquads(function(p2)
				v5(p2)
			end, nil)
		end,
		fetchAndCacheScheduledSquadStatus = function(p2, callback)
			getScheduledSquadStatus(p2, function(p3)
				local v7 = signal2(false)
				v6(Cryo.Dictionary.join(v7, { [p3.scheduledGroupUpId] = p3 }))

				if callback then
					callback()
				end
			end, function()
				if callback then
					callback()
				end
			end)
		end
	}
end
