local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local function createAppLoadedStore()
	local sessionScopedSignal, v = createSessionScopedSignal(false)

	return {
		getAppLoaded = sessionScopedSignal,
		setAppLoaded = function(flag: boolean)
			v(flag)
		end
	}
end

return createAppLoadedStore
