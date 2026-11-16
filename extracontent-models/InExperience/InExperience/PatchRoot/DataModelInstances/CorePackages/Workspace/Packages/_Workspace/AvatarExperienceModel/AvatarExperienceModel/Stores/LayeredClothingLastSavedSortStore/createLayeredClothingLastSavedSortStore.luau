local parent = script:FindFirstAncestor("AvatarExperienceModel").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local function createEmptyLastSavedSort()
	return {}
end

local function createLayeredClothingLastSavedSortStore()
	local sessionScopedSignal, v = createSessionScopedSignal(createEmptyLastSavedSort)

	return {
		getLastSavedSort = sessionScopedSignal,
		setLastSavedSort = function(p)
			v(p)
		end,
		reset = function()
			v({})
		end
	}
end

return createLayeredClothingLastSavedSortStore
