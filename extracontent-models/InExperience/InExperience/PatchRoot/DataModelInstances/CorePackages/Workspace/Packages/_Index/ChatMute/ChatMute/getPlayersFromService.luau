local function getPlayersFromService(value: string?)
	local Players = game:GetService("Players")

	if not value then
		return {}
	end

	local v = string.lower(value)

	if string.sub(v, 1, 1) == "@" then
		local v2 = string.sub(v, 2)

		for _, v3 in Players:GetPlayers() do
			if string.lower(v3.Name) == v2 then
				return {
					{
						userId = tostring(v3.UserId),
						username = v3.Name,
						displayName = v3.DisplayName
					}
				}
			end
		end

		return {}
	else
		local result = {}

		for _, v2 in Players:GetPlayers() do
			if string.lower(v2.DisplayName) == v then
				table.insert(result, {
					userId = tostring(v2.UserId),
					username = v2.Name,
					displayName = v2.DisplayName
				})
			end
		end

		return result
	end
end

return getPlayersFromService
