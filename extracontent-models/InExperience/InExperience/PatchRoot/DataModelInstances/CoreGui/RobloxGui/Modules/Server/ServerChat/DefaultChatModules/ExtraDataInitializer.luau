local v = {
	Groups = {
		{
			GroupId = 1200769,
			ChatColor = Color3.new(1, 215 / 255, 0)
		}
	},
	Players = { {} }
}

local function MakeIsInGroup(groupId, rank) -- 1 equivalent call inferred from this helper
	assert(type(rank) == "nil" or type(rank) == "number", "requiredRank must be a number or nil")

	return function(object)
		if not (object and object.UserId) then
			return false
		end

		local _userId = object.UserId

		local v2 = false
		local success, result = pcall(function()
			if rank then
				v2 = rank < object:GetRankInGroup(groupId)
			else
				v2 = object:IsInGroup(groupId)
			end
		end)

		if not success and result then
			print("Error checking in group: " .. result)
		end

		return v2
	end
end

local function ConstructIsInGroups()
	if v.Groups then
		for _, group in pairs(v.Groups) do
			group.IsInGroup = MakeIsInGroup(group.GroupId, group.Rank) -- inferred equivalent call
		end
	end
end
ConstructIsInGroups()

local Players = game:GetService("Players")

local function GetSpecialChatColor(childName)
	if v.Players then
		local child = Players:FindFirstChild(childName)

		if child then
			for _, player in pairs(v.Players) do
				if child.UserId == player.UserId then
					return player.ChatColor
				end
			end
		end
	end

	if v.Groups then
		for _, group in pairs(v.Groups) do
			if group.IsInGroup(Players:FindFirstChild(childName)) then
				return group.ChatColor
			end
		end
	end
end

local function Run(object)
	local v2 = {
		Color3.new(253 / 255, 41 / 255, 67 / 255),
		Color3.new(1 / 255, 162 / 255, 1),
		Color3.new(2 / 255, 184 / 255, 87 / 255),
		BrickColor.new("Bright violet").Color,
		BrickColor.new("Bright orange").Color,
		BrickColor.new("Bright yellow").Color,
		BrickColor.new("Light reddish violet").Color,
		BrickColor.new("Brick yellow").Color
	}

	local function GetNameValue(value)
		local nameValue = 0

		for i = 1, #value do
			local v3 = string.byte((string.sub(value, i, i)))
			local v4 = #value - i + 1

			if #value % 2 == 1 then
				v4 -= 1
			end

			if v4 % 4 >= 2 then
				v3 = -v3
			end

			nameValue += v3
		end

		return nameValue
	end

	local function ComputeNameColor(name) -- 1 equivalent call inferred from this helper
		return v2[(GetNameValue(name) + 0) % #v2 + 1]
	end

	local function GetNameColor(speaker) -- 2 equivalent calls inferred from this helper
		local player = speaker:GetPlayer()

		if player and player.Team ~= nil then
			return player.TeamColor.Color
		end

		return ComputeNameColor(speaker.Name) -- inferred equivalent call
	end

	local function onNewSpeaker(p)
		local speaker = object:GetSpeaker(p)

		if not speaker:GetExtraData("NameColor") then
			speaker:SetExtraData("NameColor", GetNameColor(speaker)) -- inferred equivalent call
		end

		local v3 = not speaker:GetExtraData("ChatColor") and GetSpecialChatColor(p)

		if v3 then
			speaker:SetExtraData("ChatColor", v3)
		end

		if not speaker:GetExtraData("Tags") then
			speaker:SetExtraData("Tags", {})
		end
	end

	object.SpeakerAdded:connect(onNewSpeaker)

	for _, v3 in pairs(object:GetSpeakerList()) do
		onNewSpeaker(v3)
	end

	local v3 = {}
	Players.PlayerAdded:connect(function(p)
		v3[p] = p.Changed:connect(function(p2)
			local speaker = object:GetSpeaker(p.Name)

			if speaker and (p2 == "TeamColor" or p2 == "Neutral" or p2 == "Team") then
				speaker:SetExtraData("NameColor", GetNameColor(speaker)) -- inferred equivalent call
			end
		end)
	end)

	Players.PlayerRemoving:connect(function(p)
		local connection = v3[p]

		if connection then
			connection:Disconnect()
		end

		v3[p] = nil
	end)
end

return Run
