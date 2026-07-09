local Parent = script:FindFirstAncestor("BackDisableStore").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local t1 = {}
local v6, v7 = createSignal(0)
local v8 = createComputed(function(p1) -- line: 13
	-- upvalues: v6 (copy)
	return v6(p1) > 0
end)

t1.getCount = v6
t1.getIsDisabled = v8

function t1.setDisabled(b1: boolean) -- line: 20
	-- upvalues: v7 (copy)
	v7(function(n1: number) -- line: 21
		-- upvalues: b1 (copy)
		if b1 then
			return n1 + 1
		end

		return (math.max(n1 - 1, 0))
	end)
end
function t1._resetForTesting() -- line: 30
	-- upvalues: v7 (copy)
	v7(0)
end

return t1
