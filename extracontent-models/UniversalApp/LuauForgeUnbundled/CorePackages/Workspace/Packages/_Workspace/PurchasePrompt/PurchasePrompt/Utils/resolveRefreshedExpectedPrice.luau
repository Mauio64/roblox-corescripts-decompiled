local function resolveRefreshedExpectedPrice(data, p2, p3, p4)
	local price = nil

	if p3 and p3 ~= "" then
		if p2 ~= nil and p2.data ~= nil then
			for i, v6 in ipairs(p2.data) do
				if v6.collectibleItemInstanceId == p3 then
					price = v6.price
					break
				end
			end
		end

		if price == nil and data ~= nil then
			return data.lowestResalePrice
		end
	elseif p4 and p4 ~= 0 then
		if data == nil or not data.timedOptions then
			return price
		end

		for i, timedOption in ipairs(data.timedOptions) do
			if timedOption.days == p4 then
				return timedOption.price
			end
		end
	elseif data ~= nil then
		price = data.price
	end

	return price
end

return resolveRefreshedExpectedPrice
