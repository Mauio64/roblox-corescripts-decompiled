local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local createSignal = require(Parent.Signals).createSignal

local function createEditsStore() -- line: 25
	-- upvalues: createSignal (copy)
	local v4, v5 = createSignal({})

	return {
		getMap = v4,
		setCommitted = function(s1: string, p1) -- line: 28
			-- upvalues: v4 (copy), v5 (copy)
			local v8 = table.clone(v4(false))

			v8[s1] = p1
			v5(v8)
		end,
		clear = function() -- line: 34
			-- upvalues: v5 (copy)
			v5({})
		end
	}
end

return createEditsStore
