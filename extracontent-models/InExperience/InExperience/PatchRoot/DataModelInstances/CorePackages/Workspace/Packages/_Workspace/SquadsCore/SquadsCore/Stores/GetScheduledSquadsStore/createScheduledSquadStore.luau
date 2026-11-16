local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

local createComputed = Signals.createComputed

local NetworkRequests = require(SquadsCore.NetworkRequests)
local getSubscribedScheduledSquads = NetworkRequests.getSubscribedScheduledSquads
local NetworkRequests2 = require(SquadsCore.NetworkRequests)
local getScheduledSquadStatus = NetworkRequests2.getScheduledSquadStatus
require(SquadsCore.Types)

return function()
	local signal, v = Signals.createSignal({})

	local signal2, v2 = Signals.createSignal({})

	local function fn(p) -- 1 equivalent call inferred from this helper
		local v3 = signal2(false)
		v2(Cryo.Dictionary.join(v3, { [p.scheduledGroupUpId] = p }))
	end

	return {
		getSubscribedScheduledSquads = createComputed(function(p)
			return signal(p)
		end),
		getScheduledSquadsStatus = createComputed(function(p)
			return signal2(p)
		end),
		fetchSubscribedScheduledSquads = function()
			getSubscribedScheduledSquads(function(p)
				v(p)
			end, nil)
		end,
		fetchAndCacheScheduledSquadStatus = function(p: number, callback)
			getScheduledSquadStatus(p, function(p2)
				fn(p2) -- inferred equivalent call

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
