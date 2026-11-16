local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Rodux = require(parent.Rodux)

local CreationFlow = require(MomentsCreationFlow.Reducers.CreationFlow)
local Music = require(MomentsCreationFlow.Reducers.Music)

return function()
	return Rodux.combineReducers({ CreationFlow = CreationFlow, Music = Music })
end
