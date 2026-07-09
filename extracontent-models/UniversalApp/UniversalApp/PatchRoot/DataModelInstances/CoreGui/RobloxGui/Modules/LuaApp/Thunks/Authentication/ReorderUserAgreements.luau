return function(p1) -- line: 3
	local v2 = nil
	local v3 = nil
	local t1 = {}
	local t2 = {}

	for _, v in ipairs(p1) do
		if v.agreementType == "TermsOfService" then
			v2 = v
		elseif v.agreementType == "PrivacyPolicy" then
			v3 = v
		elseif string.find(v.agreementType, "Optional") then
			table.insert(t1, v)
		else
			table.insert(t2, v)
		end
	end

	local t3 = {}

	if v2 then
		table.insert(t3, v2)
	end

	if v3 then
		table.insert(t3, v3)
	end

	for _, v in ipairs(t2) do
		table.insert(t3, v)
	end

	for _, v in ipairs(t1) do
		table.insert(t3, v)
	end

	return t3
end
