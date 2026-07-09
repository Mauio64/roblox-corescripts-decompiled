return function(p1) -- line: 1
	local t1 = {}

	if p1 ~= nil and (p1.errors ~= nil and p1.errors[1] and p1.errors[1].fieldData) then
		local n1 = 0

		for match in string.gmatch(p1.errors[1].fieldData, "([^,]+)") do
			t1[n1] = match
			n1 += 1
		end
	end

	if #t1 >= 1 then
		return t1[0], t1[1]
	end

	if #t1 == 0 and t1[0] ~= nil then
		return "", t1[0]
	end

	return "", ""
end
