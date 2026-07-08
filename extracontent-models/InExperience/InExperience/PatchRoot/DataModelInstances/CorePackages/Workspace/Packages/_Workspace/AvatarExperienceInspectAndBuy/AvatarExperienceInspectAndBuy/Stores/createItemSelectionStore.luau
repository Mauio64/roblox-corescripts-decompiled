local Parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local Signals = require(Parent.Signals)

require(Parent.AXCommon)

local function createItemSelectionStore() -- line: 38
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal({})
	local t1 = {}

	return {
		getItemDataMap = v4,
		getItemData = function(s1: string) -- line: 44
			-- upvalues: t1 (copy), Signals (copy), v4 (copy)
			if t1[s1] == nil then
				t1[s1] = Signals.createComputed(function(p1) -- line: 46
					-- upvalues: v4 (copy), s1 (copy)
					return v4(p1)[s1]
				end)
			end

			return t1[s1]
		end,
		setItemData = function(s2: string, t2: {[any]: any}) -- line: 54
			-- upvalues: v4 (copy), v5 (copy)
			local v10 = table.clone(v4(false))

			v10[s2] = t2
			v5(v10)
		end,
		clearItemData = function(s3: string) -- line: 60
			-- upvalues: v4 (copy), v5 (copy)
			local v12 = table.clone(v4(false))

			v12[s3] = nil
			v5(v12)
		end,
		clearAll = function() -- line: 66
			-- upvalues: v5 (copy)
			v5({})
		end
	}
end

return createItemSelectionStore
