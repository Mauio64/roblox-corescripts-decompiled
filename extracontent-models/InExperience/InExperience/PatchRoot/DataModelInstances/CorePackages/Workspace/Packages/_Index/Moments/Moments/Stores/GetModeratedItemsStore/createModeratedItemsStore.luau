local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local Cryo = require(Parent.Cryo)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createModeratedItemsStore() -- line: 18
	-- upvalues: createSignal (copy), createComputed (copy), Cryo (copy)
	local v7, v8 = createSignal({})
	local t1 = {}

	return {
		getItems = v7,
		getIsModerated = function(s1: string) -- line: 22
			-- upvalues: t1 (copy), createComputed (copy), v7 (copy)
			if t1[s1] == nil then
				t1[s1] = createComputed(function(p1) -- line: 24
					-- upvalues: v7 (copy), s1 (copy)
					return table.find(v7(p1), s1) ~= nil
				end)
			end

			return t1[s1]
		end,
		markReported = function(s2: string) -- line: 31
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy)
			local v12 = v7(false)

			if not table.find(v12, s2) then
				v8((Cryo.List.join(v12, { s2 })))
			end
		end,
		addModeratedItems = function(t2: {[any]: any}) -- line: 38
			-- upvalues: v7 (copy), v8 (copy), Cryo (copy)
			local v14 = v7(false)
			local t3 = {}

			for _, v17 in t2 do
				if not table.find(v14, v17) then
					table.insert(t3, v17)
				end
			end

			if #t3 > 0 then
				v8((Cryo.List.join(v14, t3)))
			end
		end
	}
end

return createModeratedItemsStore
