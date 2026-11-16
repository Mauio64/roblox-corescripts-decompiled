local Reducers = require(script.Reducers)
local Actions = require(script.Actions)
local Models = require(script.Models)
local Enums = require(script.Enums)
local Hooks = require(script.Hooks)
local Logger = require(script.Logger)
local RoduxSquadsTypes = require(script.RoduxSquadsTypes)

local parent = script.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)
local RoduxNetworking = require(parent.RoduxNetworking)
local NetworkingSquads = require(parent.NetworkingSquads)

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForSquadExperienceInviteStatus = SharedFlags.FFlagUseSignalsForSquadExperienceInviteStatus
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUseSignalsForSquadExperienceInvite = SharedFlags2.FFlagUseSignalsForSquadExperienceInvite

return {
	["jest.config"] = script["jest.config"],
	config = function(p)
		local joined = Cryo.Dictionary.join(p, {
			NetworkingSquads = NetworkingSquads.config({ roduxNetworking = RoduxNetworking.mock() })
		})

		local currentSquad, currentSquadPersist, currentSquadPersistManager = Reducers.currentSquad(joined)
		return {
			installReducer = function()
				local combineReducers = Rodux.combineReducers
				local v = {
					currentSquad = currentSquad,
					currentSquadPersist = currentSquadPersist,
					currentExperienceInvite = 0,
					currentExperienceInviteStatus = 0
				}
				local currentExperienceInvite

				if not FFlagUseSignalsForSquadExperienceInvite then
					currentExperienceInvite = Reducers.currentExperienceInvite(joined)
				end

				v.currentExperienceInvite = currentExperienceInvite
				local currentExperienceInviteStatus

				if not FFlagUseSignalsForSquadExperienceInviteStatus then
					currentExperienceInviteStatus = Reducers.currentExperienceInviteStatus()
				end

				v.currentExperienceInviteStatus = currentExperienceInviteStatus
				return combineReducers(v)
			end,
			PersistManagers = { currentSquadPersistManager = currentSquadPersistManager },
			Actions = Actions,
			Models = Models,
			Enums = Enums
		}
	end,
	Hooks = Hooks,
	Logger = Logger,
	RoduxSquadsTypes = RoduxSquadsTypes
}
