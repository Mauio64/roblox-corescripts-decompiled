require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsUtils").createSessionScopedSignal

local function createVersionInformationStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(function(): nil
		return nil
	end)

	local function saveDraft(p2, p3, p4)
		v5({ placeId = p2, title = p3, description = p4 })
	end

	return {
		getDraft = sessionScopedSignal,
		setDraft = saveDraft,
		clearDraft = function(p2)
			local v6 = sessionScopedSignal()

			if v6 ~= nil and v6.placeId == p2 then
				v5(nil)
			end
		end,
		reset = function()
			v5(nil)
		end
	}
end

return createVersionInformationStore
