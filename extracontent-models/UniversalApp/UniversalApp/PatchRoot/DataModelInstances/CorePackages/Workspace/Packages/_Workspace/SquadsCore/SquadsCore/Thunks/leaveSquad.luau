local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local Logger = require(SquadsCore.Logger)
local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)

require(SquadsCore.Enums.SquadPromptType)

local SquadRccEventManager = require(SquadsCore.ServiceManager.SquadRccEventManager)
local Promise = require(SquadsCoreParent.Promise)
local CurrentSquadUpdated = require(SquadsCore.RoduxSquads).Actions.CurrentSquadUpdated
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)

return function(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?, s1: string, b1: boolean) -- line: 14
	-- upvalues: Promise (copy), SquadLocationEnum (copy), SquadRccEventManager (copy), CurrentSquadUpdated (copy), NetworkingSquads (copy), Logger (copy)
	return function(p4) -- line: 21
		-- upvalues: Promise (copy), p3 (copy), s1 (copy), SquadLocationEnum (copy), SquadRccEventManager (copy), b1 (copy), CurrentSquadUpdated (copy), NetworkingSquads (copy), Logger (copy), p1 (copy), p2 (copy)
		local v15 = p4:getState()
		local v16 = v15.Squad and (v15.Squad.Squad and (v15.Squad.Squad.currentSquad and v15.Squad.Squad.currentSquad.squadId))

		if not v16 then
			return Promise.resolve()
		end

		local function v17() -- line: 33
			-- upvalues: p3 (copy), s1 (copy), SquadLocationEnum (copy), SquadRccEventManager (copy), b1 (copy), p4 (copy), CurrentSquadUpdated (copy), NetworkingSquads (copy), v16 (copy), Logger (copy)
			if p3 then
				p3()
			end

			if s1 == SquadLocationEnum.InExperience then
				SquadRccEventManager:setLeaveSquadPendingAndFireEvent(true, b1)
			end

			p4:dispatch(CurrentSquadUpdated(nil))
			p4:dispatch(NetworkingSquads.LeaveSquad.API({
				squadId = v16
			})):andThen(function() -- line: 45
				-- upvalues: s1 (copy), SquadLocationEnum (copy), SquadRccEventManager (copy), b1 (copy)
				if s1 == SquadLocationEnum.InExperience then
					SquadRccEventManager:setLeaveSquadPendingAndFireEvent(false, b1)
				end
			end):catch(function(p5) -- line: 50
				-- upvalues: Logger (copy)
				Logger:error("Error occured with NetworkingSquads.LeaveSquad: {}", (tostring(p5)))
			end)
		end

		if p1 then
			return p2(p4, {
				onConfirm = v17,
				promptType = p1
			})
		end

		v17()

		return Promise.resolve()
	end
end
