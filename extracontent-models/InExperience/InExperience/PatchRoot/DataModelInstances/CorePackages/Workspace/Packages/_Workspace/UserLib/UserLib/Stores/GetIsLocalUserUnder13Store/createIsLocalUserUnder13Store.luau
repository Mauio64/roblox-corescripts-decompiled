local parent = script:FindFirstAncestor("UserLib").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

return function()
	local sessionScopedSignal, setIsLocalUserUnder = createSessionScopedSignal(false)

	return {
		getIsLocalUserUnder13 = sessionScopedSignal,
		setIsLocalUserUnder13 = setIsLocalUserUnder,
		reset = function()
			setIsLocalUserUnder(false)
		end
	}
end
