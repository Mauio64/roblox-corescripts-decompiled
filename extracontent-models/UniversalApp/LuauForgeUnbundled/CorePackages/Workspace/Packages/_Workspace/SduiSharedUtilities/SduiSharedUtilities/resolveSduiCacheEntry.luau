local fFlagSduiAlwaysCacheWithIdentifier = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiAlwaysCacheWithIdentifier

local function resolveSduiCacheEntry(items, p2, p3)
	if not items then
		return nil
	end

	local item = items[p3 or p2]

	if item then
		return item
	end

	if p3 ~= nil then
		return nil
	end

	if fFlagSduiAlwaysCacheWithIdentifier then
		local v5 = nil

		for k, item2 in items do
			if v5 ~= nil then
				return nil
			end

			v5 = item2
		end

		return v5
	end

	for k, item2 in items do
		return item2
	end

	return nil
end

return resolveSduiCacheEntry
