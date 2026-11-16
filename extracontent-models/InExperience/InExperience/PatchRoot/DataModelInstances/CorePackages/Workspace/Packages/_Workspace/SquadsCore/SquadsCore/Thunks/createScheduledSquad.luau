local SquadsCore = script:FindFirstAncestor("SquadsCore")

local createScheduledSquad = require(SquadsCore.NetworkRequests.createScheduledSquad)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
require(SquadsCore.Types)

return function(p, callback, callback2)
	return function(p2)
		createScheduledSquad(p, callback2, function(p3: number)
			local promptType

			if p3 == 409 then
				promptType = SquadPromptType.ScheduledSquadConflict
			else
				promptType = SquadPromptType.Error
			end

			callback(p2, { promptType = promptType })
		end)
	end
end
