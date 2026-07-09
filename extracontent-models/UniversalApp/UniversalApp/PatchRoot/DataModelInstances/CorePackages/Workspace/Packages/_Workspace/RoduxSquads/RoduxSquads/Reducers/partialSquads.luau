local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local RoduxSquadsParent = RoduxSquads.Parent
local Cryo = require(RoduxSquadsParent.Cryo)
local Rodux = require(RoduxSquadsParent.Rodux)
local PartialSquadAdded = require(RoduxSquads.Actions).PartialSquadAdded
local PartialSquadRemoved = require(RoduxSquads.Actions).PartialSquadRemoved
local PartialSquadModel = require(RoduxSquads.Models).PartialSquadModel

require(script.Parent.Parent.RoduxSquadsTypes)

local t1 = {}

return function() -- line: 16
	-- upvalues: Rodux (copy), t1 (copy), PartialSquadAdded (copy), PartialSquadModel (copy), Cryo (copy), PartialSquadRemoved (copy)
	return Rodux.createReducer(t1, {
		[PartialSquadAdded.name] = function(p1, p2) -- line: 18
			-- upvalues: PartialSquadModel (copy), Cryo (copy)
			local v11 = PartialSquadModel.format(p2.payload.partialSquad)

			return Cryo.Dictionary.join(p1, {
				[v11.channelId] = v11
			})
		end,
		[PartialSquadRemoved.name] = function(p3, p4) -- line: 26
			-- upvalues: Cryo (copy)
			local channelId = p4.payload.channelId

			return Cryo.Dictionary.join(p3, {
				[channelId] = Cryo.None
			})
		end
	})
end
