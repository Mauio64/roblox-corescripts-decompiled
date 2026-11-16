local parent = script.Parent.Parent
local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local Rodux = require(parent2.Rodux)

local MomentsEligibilityReceived = require(parent.Actions.MomentsEligibilityReceived)

return Rodux.createReducer({ byUniverseId = {} }, {
	[MomentsEligibilityReceived.name] = function(p, p2)
		return {
			byUniverseId = Cryo.Dictionary.join(p.byUniverseId, { [p2.universeId] = p2.isEligible })
		}
	end
})
