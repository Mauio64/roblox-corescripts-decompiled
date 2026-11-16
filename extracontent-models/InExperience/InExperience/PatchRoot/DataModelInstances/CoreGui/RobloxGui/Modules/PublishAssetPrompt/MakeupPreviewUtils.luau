local AssetService = game:GetService("AssetService")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local FFlagSharedMakeupThumbnailCamera = Thumbnailing.FFlagSharedMakeupThumbnailCamera

local parent = script.Parent
local Constants = require(parent.Constants)

local brickColor = BrickColor.new(194)

local function makeCameraCFrame(vector3: Vector3, vector3_2: Vector3)
	return CFrame.lookAt(vector3, vector3 + vector3_2)
end
local cframe = CFrame.lookAt(Vector3.new(0, 0.0936213, -15.755899), Vector3.new(0, 0.0936213, -14.755899))
local cframes = {
	[Enum.AvatarAssetType.FaceMakeup] = cframe,
	[Enum.AvatarAssetType.LipMakeup] = CFrame.lookAt(
		Vector3.new(0, -0.2991416, -6.4134803),
		Vector3.new(0, -0.2991416, -5.4134803)
	),
	[Enum.AvatarAssetType.EyeMakeup] = CFrame.lookAt(
		Vector3.new(0, 0.10852961, -9.357428),
		Vector3.new(0, 0.10852961, -8.357428)
	),
	[Enum.AvatarAssetType.EyebrowAccessory] = CFrame.lookAt(
		Vector3.new(4.5928926, 0.37917417, -7.374273),
		Vector3.new(4.0461125, 0.35952252, -6.537227)
	),
	[Enum.AvatarAssetType.EyelashAccessory] = CFrame.lookAt(
		Vector3.new(4.593966, 0.2791934, -7.375918),
		Vector3.new(4.047186, 0.25954175, -6.5388722)
	)
}

local MakeupPreviewUtils = {}

function MakeupPreviewUtils.getHeadPreviewCameraData(instance)
	local head = instance:FindFirstChild("Head")

	if head and head:IsA("MeshPart") and not instance:FindFirstChild("HumanoidRootPart") then
		return head.CFrame, head.Size
	end

	return nil, nil
end

function MakeupPreviewUtils.setupMakeupThumbnailCamera(instance, p, p2): boolean
	local head = instance:FindFirstChild("Head")

	if not (head and head:IsA("MeshPart")) then
		return false
	end

	if FFlagSharedMakeupThumbnailCamera then
		local setupCamera = Thumbnailing.MakeupCameraUtility.SetupCamera
		local cframe2 = head.CFrame
		local v

		if p2 then
			v = p2.Value
		end

		setupCamera(p, cframe2, v)
		return true
	else
		local v = cframe

		v = p2 and cframes[p2] or v

		p.CFrame = head.CFrame * v
		p.Focus = head.CFrame
		p.FieldOfView = 5
		return true
	end
end

function MakeupPreviewUtils.isMakeupAssetType(p): boolean
	return Constants.MakeupAssetTypes[p] == true
end

local v = {
	[Enum.AvatarAssetType.FaceMakeup] = Enum.MakeupType.Face,
	[Enum.AvatarAssetType.LipMakeup] = Enum.MakeupType.Lip,
	[Enum.AvatarAssetType.EyeMakeup] = Enum.MakeupType.Eye
}

local v2 = {
	[Enum.AvatarAssetType.EyebrowAccessory] = Enum.AccessoryType.Eyebrow,
	[Enum.AvatarAssetType.EyelashAccessory] = Enum.AccessoryType.Eyelash
}

local set = {
	[Enum.AccessoryType.Hat] = true,
	[Enum.AccessoryType.Hair] = true,
	[Enum.AccessoryType.Face] = true,
	[Enum.AccessoryType.Eyebrow] = true,
	[Enum.AccessoryType.Eyelash] = true
}

local function removeMatchingChildren(parent2, fn)
	for _, child in ipairs(parent2:GetChildren()) do
		if fn(child) then
			child:Destroy()
		end
	end
end

local function addAssetToDescription(parent2, instance, p)
	local makeupType = p and v[p]
	local accessoryType = p and v2[p]

	if makeupType then
		removeMatchingChildren(parent2, function(makeupDescription)
			return makeupDescription:IsA("MakeupDescription")
		end)

		local makeupDescription = Instance.new("MakeupDescription")
		makeupDescription.MakeupType = makeupType
		makeupDescription.Instance = instance
		makeupDescription.Parent = parent2
	elseif accessoryType then
		removeMatchingChildren(parent2, function(accessoryDescription)
			return accessoryDescription:IsA("AccessoryDescription")
				and accessoryDescription.AccessoryType == accessoryType
		end)

		local accessoryDescription = Instance.new("AccessoryDescription")
		accessoryDescription.AccessoryType = accessoryType
		accessoryDescription.Instance = instance
		accessoryDescription.IsLayered = true
		accessoryDescription.Parent = parent2
	end
end

function MakeupPreviewUtils.stripToHead(instance)
	local head = instance:FindFirstChild("Head")

	if not head then
		return
	end

	for _, child in ipairs(instance:GetChildren()) do
		if child:IsA("BasePart") then
			if child ~= head then
				child:Destroy()
			end
		elseif child:IsA("Accessory") and not set[child.AccessoryType] then
			child:Destroy()
		end
	end
end

function MakeupPreviewUtils.anchorRigidPreviewParts(folder)
	for _, part in ipairs(folder:GetDescendants()) do
		if not part:IsA("BasePart") then
			continue
		end

		local accessory = part:FindFirstAncestorWhichIsA("Accessory")

		if not accessory or accessory:FindFirstChildWhichIsA("WrapLayer", true) == nil then
			part.Anchored = true
		end
	end
end

function MakeupPreviewUtils.getFolderAccessories(instance, p)
	local folderAccessories = {}

	for i, accessory in ipairs(instance:GetChildren()) do
		if not accessory:IsA("Accessory") then
			continue
		end

		local assetType

		if p and p[i] then
			assetType = p[i].assetType
		end

		table.insert(folderAccessories, { asset = accessory, assetType = assetType })
	end

	return folderAccessories
end

local function createHeadWithAsset(parent2, instance, p, list) -- 1 equivalent call inferred from this helper
	if instance then
		addAssetToDescription(parent2, instance, p)
	end

	if list then
		for _, item in ipairs(list) do
			addAssetToDescription(parent2, item.asset, item.assetType)
		end
	end

	local v3 = nil

	if not (pcall(function()
		v3 = Players:CreateHumanoidModelFromDescriptionAsync(parent2, Enum.HumanoidRigType.R15)
	end) and v3) then
		return nil
	end

	v3.Parent = workspace
	v3:GetBoundingBox()
	v3.Parent = nil

	MakeupPreviewUtils.stripToHead(v3)

	MakeupPreviewUtils.anchorRigidPreviewParts(v3)

	return v3
end

function MakeupPreviewUtils.createMakeupHeadPreview(instance, p, p2)
	local v3 = nil
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		local success, result = pcall(function()
			return Players:GetHumanoidDescriptionFromUserIdAsync(localPlayer.UserId)
		end)
		v3 = success and result or v3
	end

	return createHeadWithAsset(v3 or Instance.new("HumanoidDescription"), instance, p, p2)
end

function MakeupPreviewUtils.createMakeupThumbnailPreview(p, p2)
	local humanoidDescription = Instance.new("HumanoidDescription")
	humanoidDescription.Head = 103273511207307
	local headWithAsset = createHeadWithAsset(humanoidDescription, p, p2) -- inferred equivalent call

	if not headWithAsset then
		return nil
	end

	local bodyColors = headWithAsset:FindFirstChildOfClass("BodyColors")

	if bodyColors then
		bodyColors.HeadColor = brickColor
	end

	local head = headWithAsset:FindFirstChild("Head")

	if head then
		head.Color = brickColor.Color
	end

	return headWithAsset
end

function MakeupPreviewUtils.compositeMakeupFolder(instance, p)
	local decals = {}

	for _, decal in ipairs(instance:GetChildren()) do
		if decal:IsA("Decal") then
			table.insert(decals, decal)
		end
	end

	if #decals == 0 then
		return nil
	end

	local object = decals[1].TextureContent and decals[1].TextureContent.Object

	if not object then
		return nil
	end

	if p then
		table.sort(decals, function(a, b): boolean
			return (p[a.Name] or 0) < (p[b.Name] or 0)
		end)
	end

	local size = object.Size
	local vector2 = Vector2.new(size.X, size.Y)

	local decal = Instance.new("Decal")

	for _, v3 in ipairs({
		"TextureContent",
		"RoughnessMapContent",
		"MetalnessMapContent",
		"NormalMapContent"
	}) do
		local flag = false

		for _, v4 in ipairs(decals) do
			local v5 = v4[v3]

			if v5 and (v5.Object or v5.Uri) then
				flag = true
				break
			end
		end

		if not flag then
			continue
		end

		local editableImage = AssetService:CreateEditableImage({ Size = vector2 })
		local flag2 = false

		for _, v4 in ipairs(decals) do
			local v5 = v4[v3]

			if not v5 then
				continue
			end

			local v6 = v5.Object

			if not v6 and v5.Uri and v5.Uri ~= "" then
				local success, result = pcall(function()
					return AssetService:CreateEditableImageAsync(v5)
				end)

				if success then
					v6 = result
				end
			end

			if not v6 then
				continue
			end

			local v7

			if flag2 then
				v7 = Enum.ImageCombineType.AlphaBlend
			else
				v7 = Enum.ImageCombineType.Overwrite
			end

			editableImage:DrawImage(Vector2.new(0, 0), v6, v7)
			flag2 = true
		end

		decal[v3] = Content.fromObject(editableImage)
	end

	local wrapTextureTransfer = decals[1]:FindFirstChildWhichIsA("WrapTextureTransfer")

	if wrapTextureTransfer then
		local clone = wrapTextureTransfer:Clone()
		clone.Parent = decal
	end

	return decal
end

return MakeupPreviewUtils
