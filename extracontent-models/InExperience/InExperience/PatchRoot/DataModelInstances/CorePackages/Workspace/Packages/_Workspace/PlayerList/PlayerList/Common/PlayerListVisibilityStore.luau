local ParentParent = script.Parent.Parent.Parent
local Signals = require(ParentParent.Signals)
local v3, v4 = Signals.createSignal(true)
local v5, v6 = Signals.createSignal({})
local v7 = Signals.createComputed(function(p1) -- line: 24
	-- upvalues: v3 (copy), v5 (copy)
	return v3(p1) and next(v5(p1)) == nil
end)
local u8 = nil

return {
	getVisible = v3,
	setVisible = v4,
	getEffectiveVisible = v7,
	setTempHide = function(s1: string, b1: boolean?) -- line: 30
		-- upvalues: v5 (copy), v6 (copy), u8 (ref), v3 (copy), v4 (copy)
		local v12 = next(v5(false)) == nil

		v6(function(p2) -- line: 32
			-- upvalues: s1 (copy), b1 (copy)
			local v16 = table.clone(p2)

			v16[s1] = not not b1 or nil

			return v16
		end)

		local v13 = next(v5(false)) == nil

		if v12 and not v13 then
			u8 = v3(false)

			return
		end

		if not v12 and v13 and u8 ~= nil then
			local v14 = u8

			u8 = nil

			if v14 ~= v3(false) then
				v4(v14)
			end
		end
	end,
	reset = function() -- line: 51
		-- upvalues: u8 (ref), v6 (copy), v4 (copy)
		u8 = nil
		v6({})
		v4(true)
	end
}
