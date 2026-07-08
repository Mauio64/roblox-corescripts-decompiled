local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local Rodux = require(ParentParentParent.Rodux)
local MomentsEligibilityReceived = require(ParentParent.Actions.MomentsEligibilityReceived)
local t1 = {
	byUniverseId = {}
}

return Rodux.createReducer(t1, {
	[MomentsEligibilityReceived.name] = function(t2: {[any]: any}, p1) -- line: 18
		-- upvalues: Cryo (copy)
		return {
			byUniverseId = Cryo.Dictionary.join(t2.byUniverseId, {
				[p1.universeId] = p1.isEligible
			})
		}
	end
})
