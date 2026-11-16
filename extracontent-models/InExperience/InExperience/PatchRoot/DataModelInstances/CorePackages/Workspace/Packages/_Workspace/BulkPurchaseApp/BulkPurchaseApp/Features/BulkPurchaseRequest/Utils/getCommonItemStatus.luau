local function getCommonItemStatus(items)
	local v = nil

	for _, item in items do
		if v ~= nil and item ~= v then
			return nil
		end

		if v == nil then
			v = item
		end
	end

	return v
end

return getCommonItemStatus
