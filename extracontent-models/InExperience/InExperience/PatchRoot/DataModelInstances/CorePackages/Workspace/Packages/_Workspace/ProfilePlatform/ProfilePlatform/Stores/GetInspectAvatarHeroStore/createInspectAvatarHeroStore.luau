local parent = script:FindFirstAncestor("ProfilePlatform").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal
require(parent.React)
require(parent.EditProfileBackground)

local function createInspectAvatarHeroStore()
	local sessionScopedSignal, v = createSessionScopedSignal({})
	local sessionScopedSignal2, v2 = createSessionScopedSignal({})

	return {
		getScenes = sessionScopedSignal,
		setScene = function(p: string, p2)
			local v3 = sessionScopedSignal(false)

			if v3[p] == p2 then
				return
			end

			local clone = table.clone(v3)
			clone[p] = p2
			v(clone)
		end,
		clearScene = function(p: string, p2)
			local v3 = sessionScopedSignal(false)

			if v3[p] ~= p2 then
				return
			end

			local clone = table.clone(v3)
			clone[p] = nil
			v(clone)
		end,
		getChromeFades = sessionScopedSignal2,
		setChromeFade = function(p: string, p2)
			local v3 = sessionScopedSignal2(false)

			if v3[p] == p2 then
				return
			end

			local clone = table.clone(v3)
			clone[p] = p2
			v2(clone)
		end,
		reset = function()
			v({})
			v2({})
		end
	}
end

return createInspectAvatarHeroStore
