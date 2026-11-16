local function getPlayersFromService(value)
	local Players = game:GetService("Players")

	if not value then
		return {}
	end

	local v5 = string.lower(value)

	if string.sub(v5, 1, 1) == "@" then
		local v6 = string.sub(v5, 2)

		for k, v7 in Players:GetPlayers() do
			if string.lower(v7.Name) == v6 then
				return {
					{
						userId = tostring(v7.UserId),
						username = v7.Name,
						displayName = v7.DisplayName
					}
				}
			end
		end

		return {}
	else
		local result = {}

		for k, v6 in Players:GetPlayers() do
			if string.lower(v6.DisplayName) == v5 then
				table.insert(result, {
					userId = tostring(v6.UserId),
					username = v6.Name,
					displayName = v6.DisplayName
				})
			end
		end

		return result
	end
end

return getPlayersFromService
