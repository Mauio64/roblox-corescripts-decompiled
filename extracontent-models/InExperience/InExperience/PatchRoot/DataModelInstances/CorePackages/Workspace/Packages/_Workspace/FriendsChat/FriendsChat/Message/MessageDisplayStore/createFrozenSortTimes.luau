local parent = script:FindFirstAncestor("FriendsChat").Parent

local GetConversationMessageStore = require(parent.AppChat.GetConversationMessageStore)

local function messageSortTime(message) -- 1 equivalent call inferred from this helper
	local created_at

	if message then
		created_at = message.created_at
	end

	if created_at == nil then
		return 1e999
	end

	local dateTime = DateTime.fromIsoDate(created_at)

	if dateTime then
		return dateTime.UnixTimestampMillis
	end

	local v = tonumber(created_at)

	if v then
		return v * 1000
	end

	return 1e999
end

local function createFrozenSortTimes(p)
	local v = {}
	local now

	if p == nil then
		now = nil
	else
		now = p.now
	end

	return function(p2: string, p3)
		local v2 = v[p2]

		if v2 ~= nil then
			return v2
		end

		local message = GetConversationMessageStore(p3).getMessage(p2, p3)

		if message == nil then
			return 1e999
		end

		local v3 = messageSortTime(message) -- inferred equivalent call

		if v3 == 1e999 and now ~= nil then
			v3 = now()
		end

		v[p2] = v3
		return v3
	end
end

return createFrozenSortTimes
