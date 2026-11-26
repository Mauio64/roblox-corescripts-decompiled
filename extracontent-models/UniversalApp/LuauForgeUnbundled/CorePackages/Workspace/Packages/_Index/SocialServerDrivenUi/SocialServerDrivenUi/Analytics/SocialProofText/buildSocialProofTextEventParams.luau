local function toUserId(p2)
	if typeof(p2) == "table" then
		p2 = p2.userId or p2.user_id
	end

	local v5 = tonumber(p2)

	if v5 then
		return (string.format("%d", v5))
	end

	return nil
end

local function buildSocialProofTextEventParams(data)
	if data.universeId == nil then
		return nil
	end

	local v5 = {}

	if typeof(data.users) == "table" then
		for k, userId in data.users do
			if typeof(userId) == "table" then
				userId = userId.userId or userId.user_id
			end

			local v6 = tonumber(userId)
			local v7 = if v6 then string.format("%d", v6) else nil

			if v7 then
				table.insert(v5, v7)
			end
		end
	end

	local v6 = { table.unpack(v5, 1, (math.min(tonumber(data.avatarMax) or 2, #v5))) }
	local totalConnections = tonumber(data.totalConnections) or #v5

	return {
		universeId = tostring(data.universeId),
		placeId = data.placeId == nil and "" or tostring(data.placeId),
		totalConnections = totalConnections,
		shownUserIds = table.concat(v6, ","),
		shownUserCount = #v6,
		namedUserId = v5[1] or "",
		page = data.page or ""
	}
end

return buildSocialProofTextEventParams
