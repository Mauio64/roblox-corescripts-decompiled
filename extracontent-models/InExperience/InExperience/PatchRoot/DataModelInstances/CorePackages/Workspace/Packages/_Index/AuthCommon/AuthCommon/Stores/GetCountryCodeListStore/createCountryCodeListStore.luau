local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent

require(AuthCommonParent.Signals)

local createSessionScopedSignal = require(AuthCommonParent.SignalsUtils).createSessionScopedSignal

require(AuthCommon.Common.Types)

return function() -- line: 14
	-- upvalues: createSessionScopedSignal (copy)
	local v4, v5 = createSessionScopedSignal({})

	return {
		getCountryCodeList = v4,
		setCountryCodeList = function(p1) -- line: 17
			-- upvalues: v5 (copy)
			v5(p1)
		end,
		reset = function() -- line: 21
			-- upvalues: v5 (copy)
			v5({})
		end
	}
end
