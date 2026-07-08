local function findAnalyticsField(s1: string, t1: {[any]: any}?, p1) -- line: 2
	if not t1 then
		return nil
	end

	if t1 and t1[s1] ~= nil then
		return t1[s1]
	end

	if p1 ~= nil then
		return p1
	end

	return nil
end

return findAnalyticsField
