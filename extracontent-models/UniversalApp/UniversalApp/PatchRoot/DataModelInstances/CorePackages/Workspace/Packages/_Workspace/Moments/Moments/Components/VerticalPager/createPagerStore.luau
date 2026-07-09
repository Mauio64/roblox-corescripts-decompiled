local Parent = script:FindFirstAncestor("Moments").Parent
local Cryo = require(Parent.Cryo)
local Signals = require(Parent.Signals)
local SignalsExperimental = require(Parent.SignalsExperimental)
local snapMath = require(script.Parent.snapMath)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createPagerStore() -- line: 64
	-- upvalues: createSignal (copy), createComputed (copy), snapMath (copy), Cryo (copy), SignalsExperimental (copy)
	local v9, v10 = createSignal({})
	local v11, v12 = createSignal(1)
	local v13 = createComputed(function(p1) -- line: 68
		-- upvalues: v9 (copy)
		return #v9(p1)
	end)
	local v14 = createComputed(function(p2) -- line: 72
		-- upvalues: v9 (copy), v11 (copy)
		return v9(p2)[v11(p2)]
	end)

	return {
		getItems = v9,
		getCount = v13,
		getCurrentIndex = v11,
		getCurrentItem = v14,
		addItems = function(t1: {[any]: any}) -- line: 91
			-- upvalues: v10 (copy), Cryo (copy), v9 (copy)
			if #t1 == 0 then
				return
			end

			v10((Cryo.List.join(v9(false), t1)))
		end,
		addItemAt = function(n1: number, p3) -- line: 100
			-- upvalues: v9 (copy), SignalsExperimental (copy), v10 (copy), v11 (copy), v12 (copy), snapMath (copy)
			local v23 = v9(false)
			local v24 = #v23
			local v25 = math.clamp(n1, 1, v24 + 1)
			local v26 = table.clone(v23)

			table.insert(v26, v25, p3)
			SignalsExperimental.batch(function() -- line: 110
				-- upvalues: v10 (copy), v26 (copy), v24 (copy), v11 (copy), v25 (copy), v12 (copy), snapMath (copy)
				v10(v26)

				if v24 > 0 then
					local v31 = v11(false)

					if v31 >= v25 then
						v12(snapMath.clampIndex(v31 + 1, #v26))
					end
				end
			end)
		end,
		removeItem = function(n2: number) -- line: 123
			-- upvalues: v9 (copy), SignalsExperimental (copy), v10 (copy), v12 (copy), snapMath (copy), v11 (copy)
			local v28 = v9(false)

			if n2 < 1 or n2 > #v28 then
				return
			end

			local v29 = table.clone(v28)

			table.remove(v29, n2)
			SignalsExperimental.batch(function() -- line: 135
				-- upvalues: v10 (copy), v29 (copy), v12 (copy), snapMath (copy), v11 (copy), n2 (copy)
				v10(v29)
				v12(snapMath.reindexAfterRemoval(v11(false), n2, #v29))
			end)
		end,
		setItems = function(t2: {[any]: any}) -- line: 143
			-- upvalues: SignalsExperimental (copy), v10 (copy), v12 (copy), snapMath (copy), v11 (copy)
			SignalsExperimental.batch(function() -- line: 144
				-- upvalues: v10 (copy), t2 (copy), v12 (copy), snapMath (copy), v11 (copy)
				v10(table.clone(t2))
				v12(snapMath.clampIndex(v11(false), #t2))
			end)
		end,
		reset = function() -- line: 151
			-- upvalues: SignalsExperimental (copy), v10 (copy), v12 (copy)
			SignalsExperimental.batch(function() -- line: 152
				-- upvalues: v10 (copy), v12 (copy)
				v10({})
				v12(1)
			end)
		end,
		nextItem = function() -- line: 81
			-- upvalues: v11 (copy), v12 (copy), snapMath (copy), v9 (copy)
			local v18 = v11(false) + 1

			v12(snapMath.clampIndex(v18, #v9(false)))
		end,
		previousItem = function() -- line: 85
			-- upvalues: v11 (copy), v12 (copy), snapMath (copy), v9 (copy)
			local v19 = v11(false) - 1

			v12(snapMath.clampIndex(v19, #v9(false)))
		end,
		goToItem = function(n3: number) -- line: 77
			-- upvalues: v12 (copy), snapMath (copy), v9 (copy)
			v12(snapMath.clampIndex(n3, #v9(false)))
		end,
		dispose = function() -- line: 158
		end
	}
end

return createPagerStore
