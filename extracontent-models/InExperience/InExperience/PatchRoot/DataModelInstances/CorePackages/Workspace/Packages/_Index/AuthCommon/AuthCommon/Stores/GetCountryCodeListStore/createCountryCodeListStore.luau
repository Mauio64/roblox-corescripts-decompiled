local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal
require(AuthCommon.Common.Types)

return function()
	local sessionScopedSignal, v = createSessionScopedSignal({})

	return {
		getCountryCodeList = sessionScopedSignal,
		setCountryCodeList = function(p)
			v(p)
		end,
		reset = function()
			v({})
		end
	}
end
