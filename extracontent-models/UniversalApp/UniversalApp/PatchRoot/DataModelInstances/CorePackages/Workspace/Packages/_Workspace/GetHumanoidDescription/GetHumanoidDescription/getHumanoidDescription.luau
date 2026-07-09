local Players = game:GetService("Players")
local v2 = game:DefineFastFlag("GetHumanoidDescriptionUpdatesV2B", false)
local Parent = script:FindFirstAncestor("GetHumanoidDescription").Parent
local GetFFlagGetHumanoidDescriptionUpdatesV2E = require(Parent.SharedFlags).GetFFlagGetHumanoidDescriptionUpdatesV2E
local _ = {
	ERR_RA_CHARACTER = "ERR_RA_CHARACTER",
	ERR_RA_HUMPLAYER = "ERR_RA_HUMPLAYER",
	ERR_RA_HUMOBJ = "ERR_RA_HUMOBJ",
	ERR_RA_HUMDESC = "ERR_RA_HUMDESC",
	OK = "OK"
}

local function v6(p1) -- line: 65
	local t1 = {}

	for _, v in ipairs(p1) do
		table.insert(t1, {
			AccessoryType = v.AccessoryType.Value,
			AssetId = v.AssetId,
			IsLayered = v.IsLayered,
			Order = v.Order,
			Puffiness = v.Puffiness
		})
	end

	return t1
end
local function v7(p2, p3) -- line: 79
	local t2 = {}

	for _, v in ipairs(p3) do
		local v18 = p2[v.Name]

		if v18 then
			for i = 1, math.min(8, #v18) do
				table.insert(t2, v18[i])
			end
		end
	end

	return t2
end
local function v8(p4) -- line: 93
	local t3 = {}

	for _, v23 in (p4:GetPlayingAnimationTracks()) do
		local match = string.match(v23.Animation.AnimationId, "(%d+)$")

		if match then
			table.insert(t3, match)
		end

		if #t3 >= 8 then
			return t3
		end
	end

	return t3
end

return function(n1: number) -- line: 108
	-- upvalues: Players (copy), v6 (copy), v2 (copy), v7 (copy), GetFFlagGetHumanoidDescriptionUpdatesV2E (copy), v8 (copy)
	local PlayerByUserId = Players:GetPlayerByUserId(n1)
	local t4 = {
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
		HeadColor = {
			0,
			0,
			0
		},
		HeadScale = 0,
		HeightScale = 0,
		IdleAnimation = 0,
		JumpAnimation = 0,
		LeftArm = 0,
		LeftArmColor = {
			0,
			0,
			0
		},
		LeftLeg = 0,
		LeftLegColor = {
			0,
			0,
			0
		},
		MoodAnimation = 0,
		NeckAccessory = "",
		Pants = 0,
		ProportionScale = 0,
		RightArm = 0,
		RightArmColor = {
			0,
			0,
			0
		},
		RightLeg = 0,
		RightLegColor = {
			0,
			0,
			0
		},
		RunAnimation = 0,
		Shirt = 0,
		ShouldersAccessory = "",
		SwimAnimation = 0,
		Torso = 0,
		TorsoColor = {
			0,
			0,
			0
		},
		WaistAccessory = "",
		WalkAnimation = 0,
		WidthScale = 0
	}

	if not PlayerByUserId then
		return t4, "ERR_RA_HUMPLAYER"
	end

	local Character = PlayerByUserId.Character

	if Character then
		local Humanoid = Character:WaitForChild("Humanoid", 1)

		if not Humanoid then
			return t4, "ERR_RA_HUMOBJ"
		end

		local ok, result = pcall(function() -- line: 167
			-- upvalues: Humanoid (copy)
			return (Humanoid:GetAppliedDescription())
		end)
		local u32 = result

		if not ok then
			return t4, "ERR_RA_HUMOBJ"
		end

		if not u32 then
			return t4, "ERR_RA_HUMDESC"
		end

		local n2 = 0

		for k, _ in pairs(t4) do
			if not pcall(function(p5) -- line: 180
				-- upvalues: u32 (ref), t4 (copy)
				if typeof(u32[p5]) == "Color3" then
					t4[p5] = {
						u32[p5].R,
						u32[p5].G,
						u32[p5].B
					}

					return
				end

				t4[p5] = u32[p5]
			end, k) then
				n2 += 1
			end
		end

		local ok2, result2 = pcall(u32.GetAccessories, u32, false)

		if ok2 then
			local ok3, result3 = pcall(v6, result2)

			if ok3 then
				t4.AccessoryBlob = result3
			else
				n2 += 1
			end
		else
			n2 += 1
		end

		if v2 then
			local ok4, result4 = pcall(u32.GetEmotes, u32)

			if ok4 then
				t4.Emotes = result4
			else
				n2 += 1
			end
		end

		local ok5, result5 = pcall(u32.GetEquippedEmotes, u32)
		local ok6, result6 = pcall(u32.GetEmotes, u32)

		if ok5 and ok6 then
			local ok7, result7 = pcall(v7, result6, result5)

			if ok7 then
				t4.Emotes = result7

				if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
					local ok8, result8 = pcall(v8, Humanoid)

					if ok8 then
						t4.CurrentlyPlayingAnimationIds = result8
					else
						n2 += 1
					end
				end
			end
		else
			n2 += 1
		end

		t4.FieldErrorCount = n2

		return t4, "OK"
	end

	return t4, "ERR_RA_CHARACTER"
end
