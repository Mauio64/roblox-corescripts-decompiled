local parent = script:FindFirstAncestor("ProfilePlatform").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local function createInspectAvatarSpinIntroStore()
	local sessionScopedSignal, v = createSessionScopedSignal(false)
	local sessionScopedSignal2, v2 = createSessionScopedSignal(false)

	return {
		getHasPlayedIntro = sessionScopedSignal,
		markIntroPlayed = function()
			v(true)
		end,
		getHasDragged = sessionScopedSignal2,
		markDragged = function()
			v2(true)
		end,
		reset = function()
			v(false)
			v2(false)
		end
	}
end

return createInspectAvatarSpinIntroStore
