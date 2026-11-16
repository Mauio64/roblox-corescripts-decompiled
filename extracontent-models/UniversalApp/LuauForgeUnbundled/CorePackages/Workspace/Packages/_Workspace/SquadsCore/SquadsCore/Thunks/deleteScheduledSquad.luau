local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")
local deleteScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/NetworkRequests/deleteScheduledSquad")

return function(p2, callback, p3)
	return function(p4)
		local function fn()
			callback(p4, { promptType = SquadPromptType.Error })
		end

		return callback(p4, {
			onConfirm = function()
				deleteScheduledSquad({ scheduledGroupUpId = p2 }, p3, fn)
			end,
			promptType = SquadPromptType.ConfirmDeleteScheduledSquad
		})
	end
end
