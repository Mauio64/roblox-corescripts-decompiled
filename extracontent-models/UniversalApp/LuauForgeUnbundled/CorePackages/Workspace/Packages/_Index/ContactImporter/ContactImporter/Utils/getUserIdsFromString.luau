return function(p2)
	local v5 = {}

	if p2 ~= nil and p2.errors ~= nil and p2.errors[1] and p2.errors[1].fieldData then
		local count = 0

		for k in string.gmatch(p2.errors[1].fieldData, "([^,]+)") do
			v5[count] = k
			count += 1
		end
	end

	if #v5 >= 1 then
		return v5[0], v5[1]
	end

	if #v5 == 0 and v5[0] ~= nil then
		return "", v5[0]
	end

	return "", ""
end
