local Reducers = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Reducers")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Actions")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Models")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Enums")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Hooks")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Logger")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/RoduxSquadsTypes")

local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Cryo")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/RoduxNetworking")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/NetworkingSquads")

local fFlagUseSignalsForSquadExperienceInviteStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/SharedFlags").FFlagUseSignalsForSquadExperienceInviteStatus
local fFlagUseSignalsForSquadExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/SharedFlags").FFlagUseSignalsForSquadExperienceInvite

return {
	config = function(p2)
		local joined = Cryo.Dictionary.join(p2, {
			NetworkingSquads = module11.config({ roduxNetworking = RoduxNetworking.mock() })
		})

		local currentSquad, v5, v6 = Reducers.currentSquad(joined)
		return {
			installReducer = function()
				local combineReducers = Rodux.combineReducers
				local v7 = {
					currentSquad = currentSquad,
					currentSquadPersist = v5,
					currentExperienceInvite = 0,
					currentExperienceInviteStatus = 0
				}

				local v8 = if not fFlagUseSignalsForSquadExperienceInvite then Reducers.currentExperienceInvite(joined) else nil
				v7.currentExperienceInvite = v8

				local v9 = if not fFlagUseSignalsForSquadExperienceInviteStatus then Reducers.currentExperienceInviteStatus() else nil
				v7.currentExperienceInviteStatus = v9
				return combineReducers(v7)
			end,
			PersistManagers = { currentSquadPersistManager = v6 },
			Actions = module2,
			Models = module3,
			Enums = module4
		}
	end,
	Hooks = module5,
	Logger = module6,
	RoduxSquadsTypes = module7
}
