local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Cryo = require(parent.Cryo)
require(parent.MomentsCommon)
local Rodux = require(parent.Rodux)

local CreationFlowMusicInfoRetrieved = require(MomentsCreationFlow.Actions.CreationFlowMusicInfoRetrieved)

return Rodux.createReducer({}, {
	[CreationFlowMusicInfoRetrieved.name] = function(p, p2)
		return Cryo.Dictionary.union(p, p2.musicInfos)
	end
})
