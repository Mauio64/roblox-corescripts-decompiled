local Players = game:GetService("Players")
local scriptParent = script.Parent
local Constants = require(scriptParent.Constants)
local brickColor = BrickColor.new(194)
local t1 = {
	isMakeupAssetType = function(p1) -- line: 15
		-- upvalues: Constants (copy)
		return Constants.MakeupAssetTypes[p1] == true
	end
}
local t2 = {
	[Enum.AvatarAssetType.FaceMakeup] = Enum.MakeupType.Face,
	[Enum.AvatarAssetType.LipMakeup] = Enum.MakeupType.Lip,
	[Enum.AvatarAssetType.EyeMakeup] = Enum.MakeupType.Eye
}
local t3 = {
	[Enum.AvatarAssetType.EyebrowAccessory] = Enum.AccessoryType.Eyebrow,
	[Enum.AvatarAssetType.EyelashAccessory] = Enum.AccessoryType.Eyelash
}

local function addAssetToDescription(p2, p3, p4) -- line: 31
	-- upvalues: t2 (copy), t3 (copy)
	local v14 = p4 and t2[p4]
	local v15 = p4 and t3[p4]

	if v14 then
		for _, child in ipairs(p2:GetChildren()) do
			if child:IsA("MakeupDescription") then
				child:Destroy()
			end
		end

		local MakeupDescription = Instance.new("MakeupDescription")

		MakeupDescription.MakeupType = v14
		MakeupDescription.Instance = p3
		MakeupDescription.Parent = p2

		return
	end

	if v15 then
		local AccessoryDescription = Instance.new("AccessoryDescription")

		AccessoryDescription.AccessoryType = v15
		AccessoryDescription.Instance = p3
		AccessoryDescription.IsLayered = true
		AccessoryDescription.Parent = p2
	end
end
local function createHeadWithAsset(p5, p6, p7) -- line: 57
	-- upvalues: addAssetToDescription (copy), Players (copy)
	addAssetToDescription(p5, p6, p7)

	local u23 = nil

	if not pcall(function() -- line: 61
		-- upvalues: u23 (ref), Players (copy), p5 (copy)
		u23 = Players:CreateHumanoidModelFromDescriptionAsync(p5, Enum.HumanoidRigType.R15)
	end) or not u23 then
		return nil
	end

	local Head = u23:FindFirstChild("Head")

	if Head then
		for _, child in ipairs(u23:GetChildren()) do
			if child:IsA("BasePart") and child ~= Head then
				child:Destroy()
			end
		end
	end

	return u23
end

function t1.createMakeupHeadPreview(p8, p9) -- line: 87
	-- upvalues: Players (copy), createHeadWithAsset (copy)
	local v29 = nil
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		local ok, result = pcall(function() -- line: 91
			-- upvalues: Players (copy), LocalPlayer (copy)
			return Players:GetHumanoidDescriptionFromUserIdAsync(LocalPlayer.UserId)
		end)

		if ok and result then
			v29 = result
		end
	end

	if not v29 then
		v29 = Instance.new("HumanoidDescription")
	end

	return (createHeadWithAsset(v29, p8, p9))
end
function t1.createMakeupThumbnailPreview(p10, p11) -- line: 109
	-- upvalues: createHeadWithAsset (copy), brickColor (copy)
	local HumanoidDescription = Instance.new("HumanoidDescription")

	HumanoidDescription.Head = 103273511207307

	local v36 = createHeadWithAsset(HumanoidDescription, p10, p11)

	if not v36 then
		return nil
	end

	local BodyColors = v36:FindFirstChildOfClass("BodyColors")

	if BodyColors then
		BodyColors.HeadColor = brickColor
	end

	local Head = v36:FindFirstChild("Head")

	if Head then
		Head.Color = brickColor.Color
	end

	return v36
end

return t1
