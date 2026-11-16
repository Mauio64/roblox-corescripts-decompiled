local function some(items, callback): boolean
	for k, item in items do
		if callback(item, k) then
			return true
		end
	end

	return false
end

return some
