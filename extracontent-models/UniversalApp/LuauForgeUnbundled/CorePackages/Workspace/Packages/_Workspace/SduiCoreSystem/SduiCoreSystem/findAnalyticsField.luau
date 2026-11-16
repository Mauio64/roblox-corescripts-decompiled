local function findAnalyticsField(p2, p3, p4)
	if not p3 then
		return nil
	end

	if p3 and p3[p2] ~= nil then
		return p3[p2]
	end

	if p4 == nil then
		return nil
	end

	return p4
end

return findAnalyticsField
