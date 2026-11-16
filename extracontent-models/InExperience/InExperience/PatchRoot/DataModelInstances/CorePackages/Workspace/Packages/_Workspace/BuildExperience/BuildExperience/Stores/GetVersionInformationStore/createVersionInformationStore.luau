local parent = script:FindFirstAncestor("BuildExperience").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local function createVersionInformationStore()
	local sessionScopedSignal, v = createSessionScopedSignal(function(): nil
		return nil
	end)

	local function saveDraft(placeId: number, title: string, description: string)
		v({ placeId = placeId, title = title, description = description })
	end

	return {
		getDraft = sessionScopedSignal,
		setDraft = saveDraft,
		clearDraft = function(p: number)
			local v2 = sessionScopedSignal()

			if v2 ~= nil and v2.placeId == p then
				v(nil)
			end
		end,
		reset = function()
			v(nil)
		end
	}
end

return createVersionInformationStore
