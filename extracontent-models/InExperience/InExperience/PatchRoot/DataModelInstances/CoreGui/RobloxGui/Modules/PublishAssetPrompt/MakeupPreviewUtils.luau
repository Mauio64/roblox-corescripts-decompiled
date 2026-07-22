local AssetService = game:GetService("AssetService")
local Players = game:GetService("Players")
local scriptParent = script.Parent
local Constants = require(scriptParent.Constants)
local brickColor = BrickColor.new(194)
local t1 = {
	isMakeupAssetType = function(p1) -- line: 16
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

local function addAssetToDescription(p2, p3, p4) -- line: 32
	-- upvalues: t2 (copy), t3 (copy)
	local v15 = p4 and t2[p4]
	local v16 = p4 and t3[p4]

	if v15 then
		for _, child in ipairs(p2:GetChildren()) do
			if child:IsA("MakeupDescription") then
				child:Destroy()
			end
		end

		local MakeupDescription = Instance.new("MakeupDescription")

		MakeupDescription.MakeupType = v15
		MakeupDescription.Instance = p3
		MakeupDescription.Parent = p2

		return
	end

	if v16 then
		local AccessoryDescription = Instance.new("AccessoryDescription")

		AccessoryDescription.AccessoryType = v16
		AccessoryDescription.Instance = p3
		AccessoryDescription.IsLayered = true
		AccessoryDescription.Parent = p2
	end
end
local function createHeadWithAsset(p5, p6, p7) -- line: 58
	-- upvalues: addAssetToDescription (copy), Players (copy)
	addAssetToDescription(p5, p6, p7)

	local u24 = nil

	if not pcall(function() -- line: 62
		-- upvalues: u24 (ref), Players (copy), p5 (copy)
		u24 = Players:CreateHumanoidModelFromDescriptionAsync(p5, Enum.HumanoidRigType.R15)
	end) or not u24 then
		return nil
	end

	local Head = u24:FindFirstChild("Head")

	if Head then
		for _, child in ipairs(u24:GetChildren()) do
			if child:IsA("BasePart") and child ~= Head then
				child:Destroy()
			end
		end
	end

	return u24
end

function t1.createMakeupHeadPreview(p8, p9) -- line: 88
	-- upvalues: Players (copy), createHeadWithAsset (copy)
	local v30 = nil
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		local ok, result = pcall(function() -- line: 92
			-- upvalues: Players (copy), LocalPlayer (copy)
			return Players:GetHumanoidDescriptionFromUserIdAsync(LocalPlayer.UserId)
		end)

		if ok and result then
			v30 = result
		end
	end

	if not v30 then
		v30 = Instance.new("HumanoidDescription")
	end

	return (createHeadWithAsset(v30, p8, p9))
end
function t1.createMakeupThumbnailPreview(p10, p11) -- line: 110
	-- upvalues: createHeadWithAsset (copy), brickColor (copy)
	local HumanoidDescription = Instance.new("HumanoidDescription")

	HumanoidDescription.Head = 103273511207307

	local v37 = createHeadWithAsset(HumanoidDescription, p10, p11)

	if not v37 then
		return nil
	end

	local BodyColors = v37:FindFirstChildOfClass("BodyColors")

	if BodyColors then
		BodyColors.HeadColor = brickColor
	end

	local Head = v37:FindFirstChild("Head")

	if Head then
		Head.Color = brickColor.Color
	end

	return v37
end
function t1.compositeMakeupFolder(p12, t4: {[any]: any}?) -- line: 138
	-- upvalues: AssetService (copy)
	local t5 = {}

	for _, child in ipairs(p12:GetChildren()) do
		if child:IsA("Decal") then
			table.insert(t5, child)
		end
	end

	if #t5 == 0 then
		return nil
	end

	local v45 = t5[1].TextureContent and t5[1].TextureContent.Object

	if not v45 then
		return nil
	end

	if t4 then
		table.sort(t5, function(p13, p14) -- line: 156
			-- upvalues: t4 (copy)
			return (t4[p13.Name] or 0) < (t4[p14.Name] or 0)
		end)
	end

	local Size = v45.Size
	local vector2 = Vector2.new(Size.X, Size.Y)
	local Decal = Instance.new("Decal")

	for _, v in ipairs({
		"TextureContent",
		"RoughnessMapContent",
		"MetalnessMapContent",
		"NormalMapContent"
	}) do
		local v51 = false

		for _, v2 in ipairs(t5) do
			local v54 = v2[v]

			if v54 and (v54.Object or v54.Uri) then
				v51 = true

				break
			end
		end

		if v51 then
			local v55 = AssetService:CreateEditableImage({
				Size = vector2
			})
			local v56 = false

			for _, v3 in ipairs(t5) do
				local v59 = v3[v]

				if v59 then
					local Object = v59.Object

					if not Object and v59.Uri and v59.Uri ~= "" then
						local ok, result = pcall(function() -- line: 195
							-- upvalues: AssetService (copy), v59 (copy)
							return AssetService:CreateEditableImageAsync(v59)
						end)

						if ok then
							Object = result
						end
					end

					if Object then
						local v63 = if v56 then Enum.ImageCombineType.AlphaBlend else Enum.ImageCombineType.Overwrite

						v55:DrawImage(Vector2.new(0, 0), Object, v63)
						v56 = true
					end
				end
			end

			Decal[v] = Content.fromObject(v55)
		end
	end

	local WrapTextureTransfer = t5[1]:FindFirstChildWhichIsA("WrapTextureTransfer")

	if WrapTextureTransfer then
		WrapTextureTransfer:Clone().Parent = Decal
	end

	return Decal
end

return t1
