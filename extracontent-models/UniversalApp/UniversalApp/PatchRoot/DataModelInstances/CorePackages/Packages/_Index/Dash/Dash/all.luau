local function fn(p)
	return p
end

local function all(items, callback): boolean
	local v = callback or fn

	for k, item in items do
		if not v(item, k) then
			return false
		end
	end

	return true
end

return all
