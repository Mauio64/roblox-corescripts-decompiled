local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local Cryo = require(parent.Cryo)

local function accumulateSduiCacheSubEntries(items, options)
	local joined = Cryo.Dictionary.join(options or {}, {})

	for k, joined2 in items do
		local v = joined[k]

		if v then
			joined2 = Cryo.Dictionary.join(v, joined2)
		end

		joined[k] = joined2
	end

	return joined
end

return accumulateSduiCacheSubEntries
