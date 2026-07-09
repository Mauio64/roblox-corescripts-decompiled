local SquadsCore = script:FindFirstAncestor("SquadsCore")
local createScheduledSquad = require(SquadsCore.NetworkRequests.createScheduledSquad)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)

require(SquadsCore.Types)

return function(t1: {[any]: any}, p1: ((...any) -> ...any), p2: ((...any) -> ...any)?) -- line: 9
	-- upvalues: SquadPromptType (copy), createScheduledSquad (copy)
	return function(p3) -- line: 18
		-- upvalues: p1 (copy), SquadPromptType (copy), createScheduledSquad (copy), t1 (copy), p2 (copy)
		createScheduledSquad(t1, p2, function(n1: number) -- line: 19
			-- upvalues: p1 (copy), p3 (copy), SquadPromptType (copy)
			p1(p3, {
				promptType = if n1 ~= 409 then SquadPromptType.Error else SquadPromptType.ScheduledSquadConflict
			})
		end)
	end
end
