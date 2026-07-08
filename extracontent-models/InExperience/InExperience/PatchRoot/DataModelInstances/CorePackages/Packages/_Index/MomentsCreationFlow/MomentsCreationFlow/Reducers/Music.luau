local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Cryo = require(MomentsCreationFlowParent.Cryo)

require(MomentsCreationFlowParent.MomentsCommon)

local Rodux = require(MomentsCreationFlowParent.Rodux)
local CreationFlowMusicInfoRetrieved = require(MomentsCreationFlow.Actions.CreationFlowMusicInfoRetrieved)

return Rodux.createReducer({}, {
	[CreationFlowMusicInfoRetrieved.name] = function(t1: {[any]: any}, p1) -- line: 19
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.union(t1, p1.musicInfos)
	end
})
