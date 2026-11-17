local function toUserId(user) -- 1 equivalent call inferred from this helper
	if typeof(user) == "table" then
		user = user.userId or user.user_id
	end

	local v = tonumber(user)

	if v then
		return (string.format("%d", v))
	end

	return nil
end

local function buildSocialProofTextEventParams(data)
	if data.universeId == nil then
		return nil
	end

	local v = {}

	if typeof(data.users) == "table" then
		for _, user in data.users do
			local userId = toUserId(user) -- inferred equivalent call

			if userId then
				table.insert(v, userId)
			end
		end
	end

	local v2 = { table.unpack(v, 1, (math.min(tonumber(data.avatarMax) or 2, #v))) }
	local totalConnections = tonumber(data.totalConnections) or #v

	return {
		universeId = tostring(data.universeId),
		placeId = data.placeId == nil and "" or tostring(data.placeId),
		totalConnections = totalConnections,
		shownUserIds = table.concat(v2, ","),
		shownUserCount = #v2,
		namedUserId = v[1] or "",
		page = data.page or ""
	}
end

return buildSocialProofTextEventParams
