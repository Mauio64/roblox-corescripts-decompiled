require(script.Parent.VoiceChatServiceManager)

local function getPlayerPrimaryPart(player) -- 6 equivalent calls inferred from this helper
	return player and player.Character and player.Character.PrimaryPart
end

local function getPlayerDistanceFrom(player, vector3: Vector3) -- 5 equivalent calls inferred from this helper
	local playerPrimaryPart = getPlayerPrimaryPart(player) -- inferred equivalent call
	local playerDistanceFrom

	if playerPrimaryPart then
		playerDistanceFrom = (playerPrimaryPart.Position - vector3).Magnitude
	end

	return playerDistanceFrom
end

local VoiceUsersByProximity = {}

function VoiceUsersByProximity.getComparator(vector3: Vector3)
	return function(player, player2): boolean
		local playerPrimaryPart = getPlayerPrimaryPart(player) -- inferred equivalent call
		local playerPrimaryPart2 = getPlayerPrimaryPart(player2) -- inferred equivalent call

		if not (playerPrimaryPart or playerPrimaryPart2) then
			return player.Name:lower() < player2.Name:lower()
		end

		if playerPrimaryPart and not playerPrimaryPart2 then
			return true
		end

		if not playerPrimaryPart and playerPrimaryPart2 then
			return false
		end

		return getPlayerDistanceFrom(player, vector3) < getPlayerDistanceFrom(player2, vector3) -- inferred equivalent call
	end
end

function VoiceUsersByProximity.getSortedPlayers(object, object2, vector3: Vector3, p: number?, flag: boolean?, p2, flag2: boolean?)
	local playerByUserIds = {}

	local function fn(player, player2): boolean
		local playerPrimaryPart = getPlayerPrimaryPart(player) -- inferred equivalent call
		local playerPrimaryPart2 = getPlayerPrimaryPart(player2) -- inferred equivalent call

		if not (playerPrimaryPart or playerPrimaryPart2) then
			return player.Name:lower() < player2.Name:lower()
		end

		if playerPrimaryPart and not playerPrimaryPart2 then
			return true
		end

		if not playerPrimaryPart and playerPrimaryPart2 then
			return false
		end

		return getPlayerDistanceFrom(player, vector3) < getPlayerDistanceFrom(player2, vector3) -- inferred equivalent call
	end

	for k, _ in pairs(object2.participants) do
		local playerByUserId = object:GetPlayerByUserId(k)

		if
			not playerByUserId
			or p2 == playerByUserId
			or not (flag2 or getPlayerPrimaryPart(playerByUserId)) -- inferred equivalent call
			or p and playerByUserId and p < getPlayerDistanceFrom(playerByUserId, vector3) -- inferred equivalent call
		then
			continue
		end

		if not (not flag or object2:getRecentUsersInteractionData()[tostring(playerByUserId.UserId)]) then
			continue
		end

		table.insert(playerByUserIds, playerByUserId)
	end

	table.sort(playerByUserIds, fn)

	return playerByUserIds
end

return VoiceUsersByProximity
