local Players = game:GetService("Players")

local defineFastFlag = game:DefineFastFlag("GetHumanoidDescriptionUpdatesV2B", false)

local parent = script:FindFirstAncestor("GetHumanoidDescription").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFFlagGetHumanoidDescriptionUpdatesV2E = SharedFlags.GetFFlagGetHumanoidDescriptionUpdatesV2E

local _ = {
	ERR_RA_CHARACTER = "ERR_RA_CHARACTER",
	ERR_RA_HUMPLAYER = "ERR_RA_HUMPLAYER",
	ERR_RA_HUMOBJ = "ERR_RA_HUMOBJ",
	ERR_RA_HUMDESC = "ERR_RA_HUMDESC",
	OK = "OK"
}

local function fn(list)
	local result = {}

	for _, item in ipairs(list) do
		table.insert(result, {
			AccessoryType = item.AccessoryType.Value,
			AssetId = item.AssetId,
			IsLayered = item.IsLayered,
			Order = item.Order,
			Puffiness = item.Puffiness
		})
	end

	return result
end

local function fn2(p, list)
	local result = {}

	for _, item in ipairs(list) do
		local v = p[item.Name]

		if not v then
			continue
		end

		for i = 1, math.min(8, #v) do
			table.insert(result, v[i])
		end
	end

	return result
end

local function fn3(object)
	local playingAnimationTracks = object:GetPlayingAnimationTracks()
	local result = {}

	for _, playingAnimationTrack in playingAnimationTracks do
		local v = string.match(playingAnimationTrack.Animation.AnimationId, "(%d+)$")

		if v then
			table.insert(result, v)
		end

		if #result >= 8 then
			break
		end
	end

	return result
end

return function(p: number)
	local playerByUserId = Players:GetPlayerByUserId(p)

	local v = {
		BackAccessory = "",
		BodyTypeScale = 0,
		ClimbAnimation = 0,
		DepthScale = 0,
		Face = 0,
		FaceAccessory = "",
		FallAnimation = 0,
		FrontAccessory = "",
		GraphicTShirt = 0,
		HairAccessory = "",
		HatAccessory = "",
		Head = 0,
		HeadColor = { 0, 0, 0 },
		HeadScale = 0,
		HeightScale = 0,
		IdleAnimation = 0,
		JumpAnimation = 0,
		LeftArm = 0,
		LeftArmColor = { 0, 0, 0 },
		LeftLeg = 0,
		LeftLegColor = { 0, 0, 0 },
		MoodAnimation = 0,
		NeckAccessory = "",
		Pants = 0,
		ProportionScale = 0,
		RightArm = 0,
		RightArmColor = { 0, 0, 0 },
		RightLeg = 0,
		RightLegColor = { 0, 0, 0 },
		RunAnimation = 0,
		Shirt = 0,
		ShouldersAccessory = "",
		SwimAnimation = 0,
		Torso = 0,
		TorsoColor = { 0, 0, 0 },
		WaistAccessory = "",
		WalkAnimation = 0,
		WidthScale = 0
	}

	if not playerByUserId then
		return v, "ERR_RA_HUMPLAYER"
	end

	local character = playerByUserId.Character

	if not character then
		return v, "ERR_RA_CHARACTER"
	end

	local humanoid = character:WaitForChild("Humanoid", 1)

	if not humanoid then
		return v, "ERR_RA_HUMOBJ"
	end

	local success, result = pcall(function()
		return (humanoid:GetAppliedDescription())
	end)

	if not success then
		return v, "ERR_RA_HUMOBJ"
	end

	if not result then
		return v, "ERR_RA_HUMDESC"
	end

	local function fn4(p2)
		if typeof(result[p2]) == "Color3" then
			v[p2] = { result[p2].R, result[p2].G, result[p2].B }
		else
			v[p2] = result[p2]
		end
	end

	local count = 0

	for k, _ in pairs(v) do
		if not pcall(fn4, k) then
			count += 1
		end
	end

	local success2, accessories = pcall(result.GetAccessories, result, false)

	if success2 then
		local success3, result2 = pcall(fn, accessories)

		if success3 then
			v.AccessoryBlob = result2
		else
			count += 1
		end
	else
		count += 1
	end

	if defineFastFlag then
		local success3, emotes = pcall(result.GetEmotes, result)

		if success3 then
			v.Emotes = emotes
		else
			count += 1
		end
	end

	local success3, equippedEmotes = pcall(result.GetEquippedEmotes, result)
	local success4, emotes = pcall(result.GetEmotes, result)

	if success3 and success4 then
		local success5, result2 = pcall(fn2, emotes, equippedEmotes)

		if success5 then
			v.Emotes = result2

			if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
				local success6, result3 = pcall(fn3, humanoid)

				if success6 then
					v.CurrentlyPlayingAnimationIds = result3
				else
					count += 1
				end
			end
		end
	else
		count += 1
	end

	v.FieldErrorCount = count

	return v, "OK"
end
