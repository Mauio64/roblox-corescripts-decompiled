local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local FFlagSduiAlwaysCacheWithIdentifier = require(Parent.SharedFlags).FFlagSduiAlwaysCacheWithIdentifier

local function resolveSduiCacheEntry(t1: {[any]: any}?, s1: string, s2: string?) -- line: 15
	-- upvalues: FFlagSduiAlwaysCacheWithIdentifier (copy)
	if not t1 then
		return nil
	end

	local v7 = t1[s2 or s1]

	if v7 then
		return v7
	end

	if s2 == nil then
		if FFlagSduiAlwaysCacheWithIdentifier then
			local v8 = nil

			for _, v10 in t1 do
				if v8 ~= nil then
					return nil
				end

				v8 = v10
			end

			return v8
		end

		for _, v12 in t1 do
			return v12
		end
	end

	return nil
end

return resolveSduiCacheEntry
