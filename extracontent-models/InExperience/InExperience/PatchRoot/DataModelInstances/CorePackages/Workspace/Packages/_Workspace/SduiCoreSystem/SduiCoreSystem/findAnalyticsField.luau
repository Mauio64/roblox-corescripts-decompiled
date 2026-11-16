local function findAnalyticsField(p: string, p2, p3)
	if not p2 then
		return nil
	end

	if p2 and p2[p] ~= nil then
		return p2[p]
	end

	return if p3 ~= nil then p3 else nil
end

return findAnalyticsField
