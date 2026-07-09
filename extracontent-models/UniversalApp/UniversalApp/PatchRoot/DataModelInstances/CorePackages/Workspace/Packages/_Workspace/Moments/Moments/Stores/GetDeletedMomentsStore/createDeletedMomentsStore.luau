local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local Cryo = require(Parent.Cryo)
local createSignal = Signals.createSignal

local function createDeletedMomentsStore() -- line: 27
	-- upvalues: createSignal (copy), Cryo (copy)
	local v6, v7 = createSignal({})

	return {
		getDeletedIds = v6,
		markDeleted = function(s1: string) -- line: 30
			-- upvalues: v6 (copy), v7 (copy), Cryo (copy)
			local v9 = v6(false)

			if not table.find(v9, s1) then
				v7((Cryo.List.join(v9, { s1 })))
			end
		end
	}
end

return createDeletedMomentsStore
