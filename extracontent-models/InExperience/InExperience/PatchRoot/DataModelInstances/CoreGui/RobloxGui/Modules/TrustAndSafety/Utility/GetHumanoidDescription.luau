local Players = game:GetService("Players")
local _ = {
	ERR_RA_CHARACTER = "ERR_RA_CHARACTER",
	ERR_RA_HUMPLAYER = "ERR_RA_HUMPLAYER",
	ERR_RA_HUMOBJ = "ERR_RA_HUMOBJ",
	ERR_RA_HUMDESC = "ERR_RA_HUMDESC",
	OK = "OK"
}

return {
	getHumanoidDescription = function(n1: number) -- line: 53
		-- upvalues: Players (copy)
		local PlayerByUserId = Players:GetPlayerByUserId(n1)
		local t1 = {
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
			return t1, "ERR_RA_HUMPLAYER"
		end

		local Character = PlayerByUserId.Character

		if Character then
			local Humanoid = Character:WaitForChild("Humanoid", 1)

			if not Humanoid then
				return t1, "ERR_RA_HUMOBJ"
			end

			local AppliedDescription = Humanoid:GetAppliedDescription()

			if not AppliedDescription then
				return t1, "ERR_RA_HUMDESC"
			end

			pcall(function() -- line: 116
				-- upvalues: t1 (copy), AppliedDescription (copy)
				for k, _ in pairs(t1) do
					if typeof(AppliedDescription[k]) == "Color3" then
						t1[k] = {
							AppliedDescription[k].R,
							AppliedDescription[k].G,
							AppliedDescription[k].B
						}
					else
						t1[k] = AppliedDescription[k]
					end
				end
			end)

			return t1, "OK"
		end

		return t1, "ERR_RA_CHARACTER"
	end
}
