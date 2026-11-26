local Players = game:GetService("Players")

local defineFastFlag = game:DefineFastFlag("GetHumanoidDescriptionUpdatesV2B", false)

local getFFlagGetHumanoidDescriptionUpdatesV2E = require("@game/CorePackages/Workspace/Packages/_Workspace/GetHumanoidDescription/SharedFlags").GetFFlagGetHumanoidDescriptionUpdatesV2E

local v5 = {
	ERR_RA_CHARACTER = "ERR_RA_CHARACTER",
	ERR_RA_HUMPLAYER = "ERR_RA_HUMPLAYER",
	ERR_RA_HUMOBJ = "ERR_RA_HUMOBJ",
	ERR_RA_HUMDESC = "ERR_RA_HUMDESC",
	OK = "OK"
}

local function fn(list)
	local result = {}

	for i, item in ipairs(list) do
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

local function fn2(p2, list)
	local result = {}

	for i, item in ipairs(list) do
		local v6 = p2[item.Name]

		if not v6 then
			continue
		end

		for j = 1, math.min(8, #v6) do
			table.insert(result, v6[j])
		end
	end

	return result
end

local function fn3(object)
	local playingAnimationTracks = object:GetPlayingAnimationTracks()
	local result = {}

	for k, playingAnimationTrack in playingAnimationTracks do
		local v6 = string.match(playingAnimationTrack.Animation.AnimationId, "(%d+)$")

		if v6 then
			table.insert(result, v6)
		end

		if #result >= 8 then
			break
		end
	end

	return result
end

return function(p2)
	local playerByUserId = Players:GetPlayerByUserId(p2)

	local v6 = {
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
		return v6, "ERR_RA_HUMPLAYER"
	end

	local character = playerByUserId.Character

	if not character then
		return v6, "ERR_RA_CHARACTER"
	end

	local humanoid = character:WaitForChild("Humanoid", 1)

	if not humanoid then
		return v6, "ERR_RA_HUMOBJ"
	end

	local success, result = pcall(function()
		return humanoid:GetAppliedDescription()
	end)

	if not success then
		return v6, "ERR_RA_HUMOBJ"
	end

	if not result then
		return v6, "ERR_RA_HUMDESC"
	end

	local function fn4(p3)
		if typeof(result[p3]) == "Color3" then
			v6[p3] = { result[p3].R, result[p3].G, result[p3].B }
		else
			v6[p3] = result[p3]
		end
	end

	local count = 0

	for k, v8 in pairs(v6) do
		if not pcall(fn4, k) then
			count += 1
		end
	end

	local success2, accessories = pcall(result.GetAccessories, result, false)

	if success2 then
		local success3, result2 = pcall(fn, accessories)

		if success3 then
			v6.AccessoryBlob = result2
		else
			count += 1
		end
	else
		count += 1
	end

	if defineFastFlag then
		local success3, emotes = pcall(result.GetEmotes, result)

		if success3 then
			v6.Emotes = emotes
		else
			count += 1
		end
	end

	local success3, equippedEmotes = pcall(result.GetEquippedEmotes, result)
	local success4, emotes = pcall(result.GetEmotes, result)

	if success3 and success4 then
		local success5, result2 = pcall(fn2, emotes, equippedEmotes)

		if success5 then
			v6.Emotes = result2

			if getFFlagGetHumanoidDescriptionUpdatesV2E() then
				local success6, result3 = pcall(fn3, humanoid)

				if success6 then
					v6.CurrentlyPlayingAnimationIds = result3
				else
					count += 1
				end
			end
		end
	else
		count += 1
	end

	v6.FieldErrorCount = count

	return v6, "OK"
end
