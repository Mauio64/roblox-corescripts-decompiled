local function getUserIdsFromString(value: string)
	local v = string.split(value, ",")

	local userIds = {}

	for _, v2 in v do
		if tonumber(v2) then
			userIds[v2] = true
		end
	end

	return userIds
end

return getUserIdsFromString
