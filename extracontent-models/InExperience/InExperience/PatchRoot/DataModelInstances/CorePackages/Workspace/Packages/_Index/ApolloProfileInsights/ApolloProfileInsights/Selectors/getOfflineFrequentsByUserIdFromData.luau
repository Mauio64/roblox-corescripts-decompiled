local getProfileInsightsByUserIdFromData = require(script.Parent.getProfileInsightsByUserIdFromData)

return function(p1, p2) -- line: 3
	-- upvalues: getProfileInsightsByUserIdFromData (copy)
	local v4 = getProfileInsightsByUserIdFromData(p1, p2)

	if v4 then
		return v4.isOfflineFrequents or false
	end

	return false
end
