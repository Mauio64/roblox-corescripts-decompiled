local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local function createApplyingLayeredClothingStore()
	local sessionScopedSignal, v = createSessionScopedSignal(false)

	return {
		getApplyingLayeredClothing = sessionScopedSignal,
		startedApplyingLayeredClothing = function()
			v(true)
		end,
		finishedApplyingLayeredClothing = function()
			v(false)
		end,
		reset = function()
			v(false)
		end
	}
end

return createApplyingLayeredClothingStore
