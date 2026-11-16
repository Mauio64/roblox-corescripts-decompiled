local createScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/NetworkRequests/createScheduledSquad")
local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types")

return function(p2, p3, p4)
	return function(p5)
		createScheduledSquad(p2, p4, function(p6)
			local v8 = if p6 == 409 then SquadPromptType.ScheduledSquadConflict else SquadPromptType.Error
			p3(p5, { promptType = v8 })
		end)
	end
end
