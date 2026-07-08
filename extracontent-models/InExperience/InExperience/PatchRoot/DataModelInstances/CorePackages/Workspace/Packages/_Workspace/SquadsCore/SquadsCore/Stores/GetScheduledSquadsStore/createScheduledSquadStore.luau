local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local Cryo = require(SquadsCoreParent.Cryo)
local Signals = require(SquadsCoreParent.Signals)
local createComputed = Signals.createComputed
local getSubscribedScheduledSquads = require(SquadsCore.NetworkRequests).getSubscribedScheduledSquads
local getScheduledSquadStatus = require(SquadsCore.NetworkRequests).getScheduledSquadStatus

require(SquadsCore.Types)

return function() -- line: 25
	-- upvalues: Signals (copy), createComputed (copy), getSubscribedScheduledSquads (copy), Cryo (copy), getScheduledSquadStatus (copy)
	local v8, v9 = Signals.createSignal({})
	local v10, v11 = Signals.createSignal({})
	local v12 = createComputed(function(p1) -- line: 30
		-- upvalues: v8 (copy)
		return v8(p1)
	end)
	local v13 = createComputed(function(p2) -- line: 34
		-- upvalues: v10 (copy)
		return v10(p2)
	end)

	return {
		getSubscribedScheduledSquads = v12,
		getScheduledSquadsStatus = v13,
		fetchSubscribedScheduledSquads = function() -- line: 38
			-- upvalues: getSubscribedScheduledSquads (copy), v9 (copy)
			getSubscribedScheduledSquads(function(p3) -- line: 39
				-- upvalues: v9 (copy)
				v9(p3)
			end, nil)
		end,
		fetchAndCacheScheduledSquadStatus = function(n1: number, p4: ((...any) -> ...any)?) -- line: 49
			-- upvalues: getScheduledSquadStatus (copy), v10 (copy), v11 (copy), Cryo (copy)
			getScheduledSquadStatus(n1, function(p5) -- line: 50
				-- upvalues: v10 (copy), v11 (copy), Cryo (copy), p4 (copy)
				local v22 = v10(false)

				v11(Cryo.Dictionary.join(v22, {
					[p5.scheduledGroupUpId] = p5
				}))

				if p4 then
					p4()
				end
			end, function() -- line: 55
				-- upvalues: p4 (copy)
				if p4 then
					p4()
				end
			end)
		end
	}
end
