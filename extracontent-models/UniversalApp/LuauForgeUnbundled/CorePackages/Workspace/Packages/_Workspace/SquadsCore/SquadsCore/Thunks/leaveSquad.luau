local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local SquadLocationEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")
local SquadRccEventManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/ServiceManager/SquadRccEventManager")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Promise")

local currentSquadUpdated = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads").Actions.CurrentSquadUpdated
local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")

local GetExperienceInviteRetryAfterStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetExperienceInviteRetryAfterStore")

return function(p2, callback, callback2, p3, p4)
	return function(object)
		local state = object:getState()
		local squadId = state.Squad
			and state.Squad.Squad
			and state.Squad.Squad.currentSquad
			and state.Squad.Squad.currentSquad.squadId

		if not squadId then
			return Promise.resolve()
		end

		local function onConfirm()
			if callback2 then
				callback2()
			end

			if p3 == SquadLocationEnum.InExperience then
				SquadRccEventManager:setLeaveSquadPendingAndFireEvent(true, p4)
			end

			GetExperienceInviteRetryAfterStore(false).unblock(squadId)

			object:dispatch(currentSquadUpdated(nil))

			object:dispatch(NetworkingSquads.LeaveSquad.API({ squadId = squadId })):andThen(function()
				if p3 == SquadLocationEnum.InExperience then
					SquadRccEventManager:setLeaveSquadPendingAndFireEvent(false, p4)
				end
			end):catch(function(p5)
				Logger:error("Error occured with NetworkingSquads.LeaveSquad: {}", (tostring(p5)))
			end)
		end

		if p2 then
			return callback(object, { onConfirm = onConfirm, promptType = p2 })
		end

		onConfirm()
		return Promise.resolve()
	end
end
