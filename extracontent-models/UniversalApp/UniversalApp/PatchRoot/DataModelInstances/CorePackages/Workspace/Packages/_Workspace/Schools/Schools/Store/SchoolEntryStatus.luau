local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local createSignal = require(SchoolsParent.Signals).createSignal
local Enums = require(Schools.Common.Enums)
local v5 = createSignal(false)
local v6 = createSignal(false)
local v7 = createSignal(Enums.SchoolWaitlistVariant.School)

return {
	getVerifiedSignal = function() -- line: 21
		-- upvalues: v5 (copy)
		return v5
	end,
	getIsLiveSignal = function() -- line: 24
		-- upvalues: v6 (copy)
		return v6
	end,
	getVariantSignal = function() -- line: 27
		-- upvalues: v7 (copy)
		return v7
	end
}
