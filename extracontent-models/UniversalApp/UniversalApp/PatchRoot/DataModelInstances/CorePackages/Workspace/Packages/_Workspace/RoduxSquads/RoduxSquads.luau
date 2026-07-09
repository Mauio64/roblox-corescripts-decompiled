local Reducers = require(script.Reducers)
local Actions = require(script.Actions)
local Models = require(script.Models)
local Enums = require(script.Enums)
local Hooks = require(script.Hooks)
local Logger = require(script.Logger)
local RoduxSquadsTypes = require(script.RoduxSquadsTypes)
local scriptParent = script.Parent
local Rodux = require(scriptParent.Rodux)
local Cryo = require(scriptParent.Cryo)
local RoduxNetworking = require(scriptParent.RoduxNetworking)
local NetworkingSquads = require(scriptParent.NetworkingSquads)

return {
	["jest.config"] = script["jest.config"],
	config = function(p1) -- line: 21
		-- upvalues: Cryo (copy), NetworkingSquads (copy), RoduxNetworking (copy), Reducers (copy), Rodux (copy), Actions (copy), Models (copy), Enums (copy)
		local u14 = Cryo.Dictionary.join(p1, {
			NetworkingSquads = NetworkingSquads.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})
		local v15, v16, v17 = Reducers.currentSquad(u14)

		return {
			installReducer = function() -- line: 30
				-- upvalues: Rodux (copy), v15 (copy), v16 (copy), Reducers (copy), u14 (ref)
				return Rodux.combineReducers({
					currentSquad = v15,
					currentSquadPersist = v16,
					currentExperienceInvite = Reducers.currentExperienceInvite(u14),
					currentExperienceInviteStatus = Reducers.currentExperienceInviteStatus(),
					partialSquads = Reducers.partialSquads()
				})
			end,
			PersistManagers = {
				currentSquadPersistManager = v17
			},
			Actions = Actions,
			Models = Models,
			Enums = Enums
		}
	end,
	Hooks = Hooks,
	Logger = Logger,
	RoduxSquadsTypes = RoduxSquadsTypes
}
