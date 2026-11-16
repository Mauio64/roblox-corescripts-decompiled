local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Cryo")

local function accumulateSduiCacheSubEntries(items, options)
	local joined = Cryo.Dictionary.join(options or {}, {})

	for k, joined2 in items do
		local v5 = joined[k]

		if v5 then
			joined2 = Cryo.Dictionary.join(v5, joined2)
		end

		joined[k] = joined2
	end

	return joined
end

return accumulateSduiCacheSubEntries
