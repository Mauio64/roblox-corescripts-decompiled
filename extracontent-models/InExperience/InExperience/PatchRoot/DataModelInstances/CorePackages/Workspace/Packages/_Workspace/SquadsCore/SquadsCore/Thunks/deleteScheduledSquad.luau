local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local deleteScheduledSquad = require(SquadsCore.NetworkRequests.deleteScheduledSquad)

return function(n1: number, p1: ((...any) -> ...any), p2: ((...any) -> ...any)?) -- line: 6
	-- upvalues: SquadPromptType (copy), deleteScheduledSquad (copy)
	return function(p3) -- line: 11
		-- upvalues: p1 (copy), SquadPromptType (copy), deleteScheduledSquad (copy), n1 (copy), p2 (copy)
		local function v8() -- line: 12
			-- upvalues: p1 (copy), p3 (copy), SquadPromptType (copy)
			p1(p3, {
				promptType = SquadPromptType.Error
			})
		end

		return p1(p3, {
			onConfirm = function() -- line: 19
				-- upvalues: deleteScheduledSquad (copy), n1 (copy), p2 (copy), v8 (copy)
				deleteScheduledSquad({
					scheduledGroupUpId = n1
				}, p2, v8)
			end,
			promptType = SquadPromptType.ConfirmDeleteScheduledSquad
		})
	end
end
