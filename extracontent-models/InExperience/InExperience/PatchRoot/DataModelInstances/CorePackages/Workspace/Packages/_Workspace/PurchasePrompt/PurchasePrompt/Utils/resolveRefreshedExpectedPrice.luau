local function resolveRefreshedExpectedPrice(data, p, p2: string?, p3: number?)
	local price = nil

	if p2 and p2 ~= "" then
		if p ~= nil and p.data ~= nil then
			for _, v in ipairs(p.data) do
				if v.collectibleItemInstanceId == p2 then
					price = v.price
					break
				end
			end
		end

		if price == nil and data ~= nil then
			return data.lowestResalePrice
		end
	elseif p3 and p3 ~= 0 then
		if data == nil or not data.timedOptions then
			return price
		end

		for _, timedOption in ipairs(data.timedOptions) do
			if timedOption.days == p3 then
				return timedOption.price
			end
		end
	elseif data ~= nil then
		price = data.price
	end

	return price
end

return resolveRefreshedExpectedPrice
