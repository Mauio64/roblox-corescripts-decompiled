local function includes(items, p): boolean
	if p == nil then
		return false
	end

	for _, item in items do
		if item == p then
			return true
		end
	end

	return false
end

return includes
