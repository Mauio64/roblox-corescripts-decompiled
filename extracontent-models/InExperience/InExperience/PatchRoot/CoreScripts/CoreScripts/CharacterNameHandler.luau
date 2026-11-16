local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
game:GetService("CoreGui")

local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local UserProfileStore = UserProfiles.Stores.UserProfileStore

local defineFastFlag = game:DefineFastFlag("FixCharacterNameHandlerNilProfileCrash", false)

local v = {}

local _ = {
	CharacterAdded = "CharacterAdded",
	CharacterRemoving = "CharacterRemoving",
	HumanoidDisplayNameChanged = "HumanoidDisplayNameChanged",
	CharacterHumanoidAdded = "CharacterHumanoidAdded"
}

local function setName(humanoid, p, p2)
	local inExperienceCombinedName = p2.names.inExperienceCombinedName
	local displayName = p2.names.displayName

	if p2.names.displayName == humanoid.DisplayName then
		humanoid.InternalDisplayName = inExperienceCombinedName
		v[p].HumanoidDisplayNameChanged = humanoid:GetPropertyChangedSignal("DisplayName"):Connect(function()
			if displayName ~= humanoid.DisplayName then
				humanoid.InternalDisplayName = ""
			end
		end)
	end
end

local function checkHumanoid(player, character, p)
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid then
		setName(humanoid, player, p)
	end

	v[player].CharacterHumanoidAdded = character.ChildAdded:Connect(function(humanoid2)
		if humanoid2:IsA("Humanoid") then
			setName(humanoid2, player, p)
		end
	end)
end

local function setNameOnCharacterAdded(player, p)
	v[player] = {}

	if player.Character then
		checkHumanoid(player, player.Character, p)
	end

	v[player].CharacterAdded = player.CharacterAdded:Connect(function(character)
		checkHumanoid(player, character, p)
	end)
	v[player].CharacterRemoving = player.CharacterRemoving:Connect(function()
		local characterHumanoidAdded = v[player].CharacterHumanoidAdded
		local humanoidDisplayNameChanged = v[player].HumanoidDisplayNameChanged

		if characterHumanoidAdded then
			v[player].CharacterHumanoidAdded:Disconnect()
		end

		if humanoidDisplayNameChanged then
			v[player].HumanoidDisplayNameChanged:Disconnect()
		end
	end)
end

local function setCurrentPlayersNames()
	local players = Players:GetPlayers()
	local userIds = {}
	local playersByUserId = {}

	for _, player in pairs(players) do
		table.insert(userIds, (tostring(player.UserId)))
		playersByUserId[tostring(player.UserId)] = player
	end

	UserProfileStore.get().fetchNamesByUserIds(userIds, function(p)
		local status = p.status
		local data = p.data

		if status == "success" then
			for _, v2 in data do
				local v3 = playersByUserId[v2.userId]

				if not defineFastFlag or v3 and v2.names ~= nil then
					setNameOnCharacterAdded(v3, {
						names = {
							inExperienceCombinedName = v2.names.getInExperienceCombinedName(false),
							displayName = v2.names.getDisplayName(false)
						}
					})
				end
			end
		end
	end)
end

local function onPlayerAdded(p)
	UserProfileStore.get().fetchNamesByUserIds({ (tostring(p.UserId)) }, function(p2)
		local status = p2.status
		local data = p2.data
		local v2

		if defineFastFlag then
			if #data > 0 then
				v2 = data[1].names ~= nil
			else
				v2 = false
			end
		else
			v2 = true
		end

		if status == "success" and v2 then
			local v3 = data[1]
			setNameOnCharacterAdded(p, {
				names = {
					inExperienceCombinedName = v3.names.getInExperienceCombinedName(false),
					displayName = v3.names.getDisplayName(false)
				}
			})
		end
	end)
end

local function onPlayerRemoving(p)
	local v2 = v[p]

	if v[p] then
		for _, connection in pairs(v2) do
			connection:Disconnect()
		end

		v[p] = nil
	end

	UserProfileStore.get().invalidateCachedNamesForUserIds({ (tostring(p.UserId)) })
end

setCurrentPlayersNames()
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
