local SquadsCore = script:FindFirstAncestor("SquadsCore")

local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local deleteScheduledSquad = require(SquadsCore.NetworkRequests.deleteScheduledSquad)

return function(scheduledGroupUpId: number, callback, callback2)
	return function(p)
		local function fn()
			callback(p, { promptType = SquadPromptType.Error })
		end

		return callback(p, {
			onConfirm = function()
				deleteScheduledSquad({ scheduledGroupUpId = scheduledGroupUpId }, callback2, fn)
			end,
			promptType = SquadPromptType.ConfirmDeleteScheduledSquad
		})
	end
end
