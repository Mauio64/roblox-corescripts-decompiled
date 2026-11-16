local getProfileInsightsByUserIdFromData = require(script.Parent.getProfileInsightsByUserIdFromData)

return function(p, p2)
	local profileInsightsByUserIdFromData = getProfileInsightsByUserIdFromData(p, p2)

	if profileInsightsByUserIdFromData then
		return profileInsightsByUserIdFromData.isOfflineFrequents or false
	end

	return false
end
