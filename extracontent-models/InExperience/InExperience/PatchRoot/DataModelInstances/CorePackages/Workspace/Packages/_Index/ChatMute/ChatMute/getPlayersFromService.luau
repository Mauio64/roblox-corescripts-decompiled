local function getPlayersFromService(s1: string?) -- line: 7
	local Players = game:GetService("Players")

	if not s1 then
		return {}
	end

	local v4 = string.lower(s1)

	if string.sub(v4, 1, 1) == "@" then
		local v5 = string.sub(v4, 2)

		for _, player in Players:GetPlayers() do
			if v5 == string.lower(player.Name) then
				return {{
					userId = tostring(player.UserId),
					username = player.Name,
					displayName = player.DisplayName
				}}
			end
		end

		return {}
	end

	local t1 = {}

	for _, player in Players:GetPlayers() do
		if v4 == string.lower(player.DisplayName) then
			table.insert(t1, {
				userId = tostring(player.UserId),
				username = player.Name,
				displayName = player.DisplayName
			})
		end
	end

	return t1
end

return getPlayersFromService
