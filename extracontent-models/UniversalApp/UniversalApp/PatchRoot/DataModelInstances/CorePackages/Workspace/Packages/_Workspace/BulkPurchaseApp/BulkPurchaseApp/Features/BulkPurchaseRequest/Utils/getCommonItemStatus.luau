local function getCommonItemStatus(t1: {[any]: any}) -- line: 3
	local v3 = nil

	for _, v5 in t1 do
		if v3 ~= nil and v5 ~= v3 then
			return nil
		end

		if v3 == nil then
			v3 = v5
		end
	end

	return v3
end

return getCommonItemStatus
