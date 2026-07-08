local ParentParent = script.Parent.Parent.Parent
local Signals = require(ParentParent.Signals)
local v3, v4 = Signals.createSignal(true)
local v5, v6 = Signals.createSignal({})
local v7 = Signals.createComputed(function(p1) -- line: 24
	-- upvalues: v3 (copy), v5 (copy)
	return v3(p1) and next(v5(p1)) == nil
end)

return {
	getVisible = v3,
	setVisible = v4,
	getEffectiveVisible = v7,
	setTempHide = function(s1: string, b1: boolean?) -- line: 28
		-- upvalues: v6 (copy)
		v6(function(p2) -- line: 29
			-- upvalues: s1 (copy), b1 (copy)
			local v12 = table.clone(p2)

			v12[s1] = not not b1 or nil

			return v12
		end)
	end,
	reset = function() -- line: 38
		-- upvalues: v6 (copy), v4 (copy)
		v6({})
		v4(true)
	end
}
