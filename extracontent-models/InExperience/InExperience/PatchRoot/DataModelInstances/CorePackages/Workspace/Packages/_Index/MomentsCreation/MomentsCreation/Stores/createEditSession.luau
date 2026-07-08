local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Signals = require(MomentsCreationParent.Signals)

require(MomentsCreation.Types.CreationFlowTypes)

local createSignal = Signals.createSignal

local function createEditSession() -- line: 21
	-- upvalues: createSignal (copy)
	local v6, v7 = createSignal(nil)
	local v8, v9 = createSignal(false)
	local u10 = nil

	return {
		getDraft = v6,
		getIsDirty = v8,
		begin = function(p1) -- line: 26
			-- upvalues: u10 (ref), v7 (copy), v9 (copy)
			u10 = p1
			v7(p1)
			v9(false)
		end,
		update = function(p2) -- line: 32
			-- upvalues: v7 (copy), v9 (copy)
			v7(p2)
			v9(true)
		end,
		commit = function() -- line: 37
			-- upvalues: v6 (copy), u10 (ref), v9 (copy)
			local v13 = v6(false)

			u10 = v13
			v9(false)

			return v13
		end,
		discard = function() -- line: 44
			-- upvalues: v7 (copy), u10 (ref), v9 (copy)
			v7(u10)
			v9(false)
		end
	}
end

return createEditSession
