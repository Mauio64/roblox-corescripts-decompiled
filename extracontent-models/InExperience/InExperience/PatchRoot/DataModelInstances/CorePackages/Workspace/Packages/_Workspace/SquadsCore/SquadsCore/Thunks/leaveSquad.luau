local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Logger = require(SquadsCore.Logger)
local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)
require(SquadsCore.Enums.SquadPromptType)
local SquadRccEventManager = require(SquadsCore.ServiceManager.SquadRccEventManager)

local Promise = require(parent.Promise)

local RoduxSquads = require(SquadsCore.RoduxSquads)
local CurrentSquadUpdated = RoduxSquads.Actions.CurrentSquadUpdated
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)

local GetExperienceInviteRetryAfterStore = require(SquadsCore.Stores.GetExperienceInviteRetryAfterStore)

return function(promptType, callback, callback2, p: string, flag: boolean)
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

			if p == SquadLocationEnum.InExperience then
				SquadRccEventManager:setLeaveSquadPendingAndFireEvent(true, flag)
			end

			GetExperienceInviteRetryAfterStore(false).unblock(squadId)

			object:dispatch(CurrentSquadUpdated(nil))

			object:dispatch(NetworkingSquads.LeaveSquad.API({ squadId = squadId })):andThen(function()
				if p == SquadLocationEnum.InExperience then
					SquadRccEventManager:setLeaveSquadPendingAndFireEvent(false, flag)
				end
			end):catch(function(p2)
				Logger:error("Error occured with NetworkingSquads.LeaveSquad: {}", (tostring(p2)))
			end)
		end

		if promptType then
			return callback(object, { onConfirm = onConfirm, promptType = promptType })
		end

		onConfirm()
		return Promise.resolve()
	end
end
