local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiAlwaysCacheWithIdentifier = SharedFlags.FFlagSduiAlwaysCacheWithIdentifier

local function resolveSduiCacheEntry(items, p: string, p2: string?)
	if not items then
		return nil
	end

	local item = items[p2 or p]

	if item then
		return item
	end

	if p2 ~= nil then
		return nil
	end

	if FFlagSduiAlwaysCacheWithIdentifier then
		local v = nil

		for _, item2 in items do
			if v ~= nil then
				return nil
			end

			v = item2
		end

		return v
	end

	for _, item2 in items do
		return item2
	end

	return nil
end

return resolveSduiCacheEntry
