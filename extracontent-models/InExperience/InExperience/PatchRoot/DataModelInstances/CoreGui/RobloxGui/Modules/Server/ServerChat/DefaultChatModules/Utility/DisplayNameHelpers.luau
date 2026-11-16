local Players = game:GetService("Players")
local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local commandErrorCodes = { ChattingToSelf = 1, NoMatches = 2, MultipleMatches = 3 }
local DisplayNameHelpers = {}
DisplayNameHelpers.CommandErrorCodes = commandErrorCodes

function DisplayNameHelpers.getUserNameFromChattedName(value, p, p2)
	if p == value then
		return p, commandErrorCodes.ChattingToSelf
	end

	local players = Players:GetPlayers()

	for _, player in pairs(players) do
		if string.lower(player.Name) == string.lower(value) then
			return player.Name, nil
		end
	end

	local count = 0
	local name = nil

	if ChatSettings.PlayerDisplayNamesEnabled then
		for _, player in pairs(players) do
			if not (player.Name ~= p and string.lower(player.DisplayName) == string.lower(value)) then
				continue
			end

			count += 1
			name = player.Name
		end
	end

	if count == 1 then
		return name, nil
	end

	if count == 0 then
		if p2 == value then
			return p2, commandErrorCodes.ChattingToSelf
		end

		return value, commandErrorCodes.NoMatches
	elseif count >= 2 then
		return value, commandErrorCodes.MultipleMatches
	end
end

function DisplayNameHelpers.getUsersWithDisplayNameString(value, p)
	local players = Players:GetPlayers()
	local names = {}
	local users = ""

	for _, player in pairs(players) do
		if not (player.Name ~= p and string.lower(player.DisplayName) == string.lower(value)) then
			continue
		end

		table.insert(names, player.Name)
	end

	for k, v in pairs(names) do
		if k == #names then
			users ..= "@" .. v
		else
			users ..= "@" .. v .. ", "
		end
	end

	return users
end

return DisplayNameHelpers
