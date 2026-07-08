local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local GetFFlagGetHumanoidDescriptionUpdates = require(AbuseReportMenu.Flags.GetFFlagGetHumanoidDescriptionUpdates)
local v3 = game:DefineFastFlag("GetHumanoidDescriptionUpdatesV2A", false)
local CorePackages = game:GetService("CorePackages")
local GetFFlagGetHumanoidDescriptionUpdatesV2E = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagGetHumanoidDescriptionUpdatesV2E
local Players = game:GetService("Players")
local _ = {
	ERR_RA_CHARACTER = "ERR_RA_CHARACTER",
	ERR_RA_HUMPLAYER = "ERR_RA_HUMPLAYER",
	ERR_RA_HUMOBJ = "ERR_RA_HUMOBJ",
	ERR_RA_HUMDESC = "ERR_RA_HUMDESC",
	OK = "OK"
}

local function v8(p1) -- line: 67
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
local function v9(p2, p3) -- line: 81
	local t2 = {}

	for _, v in ipairs(p3) do
		local v20 = p2[v.Name]

		if v20 then
			for i = 1, math.min(8, #v20) do
				table.insert(t2, v20[i])
			end
		end
	end

	return t2
end
local function v10(p4) -- line: 95
	local t3 = {}

	for _, v25 in (p4:GetPlayingAnimationTracks()) do
		local match = string.match(v25.Animation.AnimationId, "(%d+)$")

		if match then
			table.insert(t3, match)
		end

		if #t3 >= 8 then
			return t3
		end
	end

	return t3
end

return {
	getHumanoidDescription = function(n1: number) -- line: 110
		-- upvalues: Players (copy), GetFFlagGetHumanoidDescriptionUpdates (copy), v8 (copy), v3 (copy), v9 (copy), GetFFlagGetHumanoidDescriptionUpdatesV2E (copy), v10 (copy)
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

			local u34

			if GetFFlagGetHumanoidDescriptionUpdates() then
				local ok, result = pcall(function() -- line: 171
					-- upvalues: Humanoid (copy)
					return (Humanoid:GetAppliedDescription())
				end)

				u34 = result

				if not ok then
					return t4, "ERR_RA_HUMOBJ"
				end
			else
				u34 = Humanoid:GetAppliedDescription()
			end

			if not u34 then
				return t4, "ERR_RA_HUMDESC"
			end

			local n2 = 0

			if GetFFlagGetHumanoidDescriptionUpdates() then
				for k, _ in pairs(t4) do
					if not pcall(function(p5) -- line: 188
						-- upvalues: u34 (ref), t4 (copy)
						if typeof(u34[p5]) == "Color3" then
							t4[p5] = {
								u34[p5].R,
								u34[p5].G,
								u34[p5].B
							}

							return
						end

						t4[p5] = u34[p5]
					end, k) then
						n2 += 1
					end
				end

				local ok, result = pcall(u34.GetAccessories, u34, false)

				if ok then
					local ok2, result2 = pcall(v8, result)

					if ok2 then
						t4.AccessoryBlob = result2
					else
						n2 += 1
					end
				else
					n2 += 1
				end

				if v3 then
					local ok3, result3 = pcall(u34.GetEmotes, u34)

					if ok3 then
						t4.Emotes = result3
					else
						n2 += 1
					end
				end

				local ok4, result4 = pcall(u34.GetEquippedEmotes, u34)
				local ok5, result5 = pcall(u34.GetEmotes, u34)

				if ok4 and ok5 then
					local ok6, result6 = pcall(v9, result5, result4)

					if ok6 then
						t4.Emotes = result6

						if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
							local ok7, result7 = pcall(v10, Humanoid)

							if ok7 then
								t4.CurrentlyPlayingAnimationIds = result7
							else
								n2 += 1
							end
						end
					end
				else
					n2 += 1
				end

				t4.FieldErrorCount = n2
			else
				pcall(function() -- line: 255
					-- upvalues: t4 (copy), u34 (ref)
					for k, _ in pairs(t4) do
						if typeof(u34[k]) == "Color3" then
							t4[k] = {
								u34[k].R,
								u34[k].G,
								u34[k].B
							}
						else
							t4[k] = u34[k]
						end
					end
				end)
			end

			return t4, "OK"
		end

		return t4, "ERR_RA_CHARACTER"
	end
}
