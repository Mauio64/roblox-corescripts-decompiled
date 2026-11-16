local function zip(items, items2)
	local v = nil
	local v2 = nil
	local v3 = nil
	local v4 = nil
	return function()
		v, v3 = next(items, v)
		v2, v4 = next(items2, v2)

		if v3 and v4 then
			return v3, v4
		end

		return nil
	end
end

return zip
