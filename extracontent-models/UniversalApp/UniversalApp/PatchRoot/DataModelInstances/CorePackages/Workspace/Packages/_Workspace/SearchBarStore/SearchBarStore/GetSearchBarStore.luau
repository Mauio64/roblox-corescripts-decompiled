local Parent = script:FindFirstAncestor("SearchBarStore").Parent
local Signals = require(Parent.Signals)
local SignalsUtils = require(Parent.SignalsUtils)

return Signals.createComputed(function() -- line: 8
	-- upvalues: SignalsUtils (copy)
	local v4, v5 = SignalsUtils.createSessionScopedSignal(false)

	return {
		getFocused = v4,
		setFocused = v5,
		reset = function() -- line: 11
			-- upvalues: v5 (copy)
			v5(false)
		end
	}
end)
