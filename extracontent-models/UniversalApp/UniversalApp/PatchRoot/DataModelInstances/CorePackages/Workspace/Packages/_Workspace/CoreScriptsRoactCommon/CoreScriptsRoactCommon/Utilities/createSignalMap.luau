local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local Signals = require(Parent.Signals)
local Cryo = require(Parent.Cryo)

local function createSignalMap(t1: {[any]: any}?) -- line: 22
	-- upvalues: Signals (copy), Cryo (copy)
	local t2 = {}
	local n1 = 0

	if t1 then
		for k, v in pairs(t1) do
			t2[k] = v
			n1 += 1
		end
	end

	local v10, v11 = Signals.createSignal(t2)
	local v12, v13 = Signals.createSignal(n1)
	local v14 = Signals.createComputed(function(p1) -- line: 60
		-- upvalues: v10 (copy)
		return v10(p1)
	end)

	return {
		getData = function(p2, p3) -- line: 35
			-- upvalues: v10 (copy)
			return v10(p3)[p2]
		end,
		setData = function(p4, p5, p6) -- line: 39
			-- upvalues: v10 (copy), Cryo (copy), v13 (copy), v12 (copy), v11 (copy)
			local v20 = v10(p6)
			local v21 = v20[p4]
			local v22 = Cryo.Dictionary.join(v20, {
				[p4] = p5
			})

			if not v21 then
				v13(v12(p6) + 1)
			end

			v11(v22)
		end,
		removeData = function(p7, p8) -- line: 49
			-- upvalues: v10 (copy), Cryo (copy), v13 (copy), v12 (copy), v11 (copy)
			local v25 = v10(p8)

			if v25[p7] then
				local v26 = Cryo.Dictionary.join(v25, {
					[p7] = Cryo.None
				})

				v13(v12(p8) - 1)
				v11(v26)
			end
		end,
		getCount = v12,
		iterateData = function(p9: ((...any) -> ...any), p10) -- line: 64
			-- upvalues: Signals (copy), v10 (copy)
			return Signals.createEffect(function() -- line: 65
				-- upvalues: v10 (copy), p10 (copy), p9 (copy)
				local v30 = v10(p10)

				for k, v in pairs(v30) do
					p9(k, v)
				end
			end)
		end,
		getAllData = v14
	}
end

return createSignalMap
