local function resolveRefreshedExpectedPrice(p1, p2, s1: string?, n1: number?) -- line: 1
	local price = nil

	if s1 and s1 ~= "" then
		if p2 ~= nil and p2.data ~= nil then
			for _, v in ipairs(p2.data) do
				if s1 == v.collectibleItemInstanceId then
					price = v.price

					break
				end
			end
		end

		if price == nil and p1 ~= nil then
			return p1.lowestResalePrice
		end
	elseif n1 and n1 ~= 0 then
		if p1 ~= nil and p1.timedOptions then
			for _, v in ipairs(p1.timedOptions) do
				if n1 == v.days then
					return v.price
				end
			end

			return price
		end
	elseif p1 ~= nil then
		price = p1.price
	end

	return price
end

return resolveRefreshedExpectedPrice
