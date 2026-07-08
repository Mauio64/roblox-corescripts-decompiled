local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local Cryo = require(Parent.Cryo)

local function accumulateSduiCacheSubEntries(t1: {[any]: any}, t2: {[any]: any}?) -- line: 7
	-- upvalues: Cryo (copy)
	local v6 = Cryo.Dictionary.join(t2 or {}, {})

	for v7, v8 in t1 do
		local v9 = v6[v7]

		v6[v7] = if not v9 then v8 else Cryo.Dictionary.join(v9, v8)
	end

	return v6
end

return accumulateSduiCacheSubEntries
