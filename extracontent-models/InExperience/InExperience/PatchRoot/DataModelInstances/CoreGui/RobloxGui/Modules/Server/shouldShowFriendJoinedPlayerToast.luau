return function(object): boolean
	local joinData = object:GetJoinData()
	local referredByPlayerId = joinData and tonumber(joinData.ReferredByPlayerId)
	return referredByPlayerId == nil or referredByPlayerId == 0
end
