local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local GetFFlagGetHumanoidDescriptionUpdates = require(AbuseReportMenu.Flags.GetFFlagGetHumanoidDescriptionUpdates)
local defineFastFlag = game:DefineFastFlag("GetHumanoidDescriptionUpdatesV2A", false)

local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagGetHumanoidDescriptionUpdatesV2E = SharedFlags.GetFFlagGetHumanoidDescriptionUpdatesV2E

local Players = game:GetService("Players")

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

return {
	getHumanoidDescription = function(p: number)
		local playerByUserId = Players:GetPlayerByUserId(p)

		local result = {
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
			return result, "ERR_RA_HUMPLAYER"
		end

		local character = playerByUserId.Character

		if not character then
			return result, "ERR_RA_CHARACTER"
		end

		local humanoid = character:WaitForChild("Humanoid", 1)

		if not humanoid then
			return result, "ERR_RA_HUMOBJ"
		end

		local result2

		if GetFFlagGetHumanoidDescriptionUpdates() then
			local success
			success, result2 = pcall(function()
				return (humanoid:GetAppliedDescription())
			end)

			if not success then
				return result, "ERR_RA_HUMOBJ"
			end
		else
			result2 = humanoid:GetAppliedDescription()
		end

		if not result2 then
			return result, "ERR_RA_HUMDESC"
		end

		local count = 0

		if GetFFlagGetHumanoidDescriptionUpdates() then
			local function fn4(p2)
				if typeof(result2[p2]) == "Color3" then
					result[p2] = { result2[p2].R, result2[p2].G, result2[p2].B }
				else
					result[p2] = result2[p2]
				end
			end

			for k, _ in pairs(result) do
				if not pcall(fn4, k) then
					count += 1
				end
			end

			local success, accessories = pcall(result2.GetAccessories, result2, false)

			if success then
				local success2, result3 = pcall(fn, accessories)

				if success2 then
					result.AccessoryBlob = result3
				else
					count += 1
				end
			else
				count += 1
			end

			if defineFastFlag then
				local success2, emotes = pcall(result2.GetEmotes, result2)

				if success2 then
					result.Emotes = emotes
				else
					count += 1
				end
			end

			local success2, equippedEmotes = pcall(result2.GetEquippedEmotes, result2)
			local success3, emotes = pcall(result2.GetEmotes, result2)

			if success2 and success3 then
				local success4, result3 = pcall(fn2, emotes, equippedEmotes)

				if success4 then
					result.Emotes = result3

					if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
						local success5, result4 = pcall(fn3, humanoid)

						if success5 then
							result.CurrentlyPlayingAnimationIds = result4
						else
							count += 1
						end
					end
				end
			else
				count += 1
			end

			result.FieldErrorCount = count
		else
			pcall(function()
				for k, _ in pairs(result) do
					if typeof(result2[k]) == "Color3" then
						result[k] = { result2[k].R, result2[k].G, result2[k].B }
					else
						result[k] = result2[k]
					end
				end
			end)
		end

		return result, "OK"
	end
}
