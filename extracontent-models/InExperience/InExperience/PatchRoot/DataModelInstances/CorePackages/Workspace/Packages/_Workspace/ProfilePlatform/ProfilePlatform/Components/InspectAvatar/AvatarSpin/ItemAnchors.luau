local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

require(parent.AvatarExperienceInspectAndBuy)
require(ProfilePlatform.Common.Types)

local function facing(normal: Vector3?, fullDegrees: number, zeroDegrees: number, value: number?) -- 3 equivalent calls inferred from this helper
	return {
		normal = normal,
		fullDegrees = fullDegrees,
		zeroDegrees = zeroDegrees,
		weight = value or 1
	}
end

local v = facing(Vector3.new(0, 0, -1), 55, 86) -- inferred equivalent call
local v2 = facing(Vector3.new(0, 0, 1), 55, 86) -- inferred equivalent call
local v3 = facing(nil, 0, 180) -- inferred equivalent call
local v4 = {
	FaceFrontAttachment = { v },
	FaceCenterAttachment = { v },
	NeckAttachment = { v },
	BodyFrontAttachment = { v },
	WaistFrontAttachment = { v },
	LeftCollarAttachment = { v },
	RightCollarAttachment = { v },
	BodyBackAttachment = {
		{ normal = Vector3.new(0, 0, 1), fullDegrees = 65, zeroDegrees = 100, weight = 1 }
	},
	WaistBackAttachment = {
		{ normal = Vector3.new(0, 0, 1), fullDegrees = 65, zeroDegrees = 100, weight = 1 }
	},
	LeftShoulderAttachment = {
		{ normal = Vector3.new(-1, 0, 0), fullDegrees = 65, zeroDegrees = 100, weight = 1 },
		{ normal = Vector3.new(0, 0, -1), fullDegrees = 35, zeroDegrees = 75, weight = 0.85 }
	},
	RightShoulderAttachment = {
		{ normal = Vector3.new(1, 0, 0), fullDegrees = 65, zeroDegrees = 100, weight = 1 },
		{ normal = Vector3.new(0, 0, -1), fullDegrees = 35, zeroDegrees = 75, weight = 0.85 }
	}
}

local v5 = {
	TShirt = Enum.AvatarAssetType.TShirt.Value,
	Shirt = Enum.AvatarAssetType.Shirt.Value,
	Pants = Enum.AvatarAssetType.Pants.Value,
	Head = Enum.AvatarAssetType.Head.Value,
	Face = Enum.AvatarAssetType.Face.Value,
	DynamicHead = Enum.AvatarAssetType.DynamicHead.Value,
	Gear = Enum.AvatarAssetType.Gear.Value
}

local v6 = {
	[v5.TShirt] = "GraphicTShirt",
	[v5.Shirt] = "Shirt",
	[v5.Pants] = "Pants",
	[v5.Head] = "Head",
	[v5.DynamicHead] = "Head",
	[v5.Face] = "Face"
}

local v7 = {
	head = { "Head" },
	torso = { "UpperTorso", "Torso" },
	legs = { "LeftUpperLeg", "Left Leg" },
	leftFoot = { "LeftFoot", "Left Leg" },
	rightFoot = { "RightFoot", "Right Leg" }
}

local function findBodyPart(instance, p: string)
	for _, childName in v7[p] do
		local part = instance:FindFirstChild(childName)

		if part and part:IsA("BasePart") then
			return part
		end
	end

	return nil
end

local function surfaceAnchors(bodyPart, items, target)
	local result = {}

	for _, item in items do
		local normal = item.normal
		local v8 = bodyPart.Size.Z / 2 + 0.05
		table.insert(result, {
			part = bodyPart,
			offset = Vector3.new(0, 0, normal.Z * v8),
			normal = normal,
			fullDegrees = item.fullDegrees,
			zeroDegrees = item.zeroDegrees,
			weight = item.weight,
			target = target
		})
	end

	return result
end

local function regionAnchors(p, p2: string, p3, accessory) -- 5 equivalent calls inferred from this helper
	local bodyPart = findBodyPart(p, p2)

	if bodyPart then
		return surfaceAnchors(bodyPart, p3, accessory or bodyPart)
	end

	return {}
end

local v8 = {
	[Enum.AccessoryType.Jacket] = "torso",
	[Enum.AccessoryType.Sweater] = "torso",
	[Enum.AccessoryType.TShirt] = "torso",
	[Enum.AccessoryType.Shirt] = "torso",
	[Enum.AccessoryType.Pants] = "legs",
	[Enum.AccessoryType.Shorts] = "legs",
	[Enum.AccessoryType.DressSkirt] = "legs",
	[Enum.AccessoryType.LeftShoe] = "leftFoot",
	[Enum.AccessoryType.RightShoe] = "rightFoot",
	[Enum.AccessoryType.Eyebrow] = "head",
	[Enum.AccessoryType.Eyelash] = "head"
}

local function accessoryAnchors(instance, accessory)
	local handle = accessory:FindFirstChild("Handle")

	if not (handle and handle:IsA("BasePart")) then
		return {}
	end

	local v9 = handle:FindFirstChildWhichIsA("WrapLayer") and accessory:IsA("Accessory") and v8[accessory.AccessoryType]

	if v9 then
		local v10

		if v9 == "head" then
			v10 = { v }
		else
			v10 = { v, v2 }
		end

		return regionAnchors(instance, v9, v10, accessory) -- inferred equivalent call
	else
		local attachment = handle:FindFirstChildWhichIsA("Attachment")
		local v10

		if attachment then
			v10 = v4[attachment.Name]
		end

		local specialMesh = handle:FindFirstChildWhichIsA("SpecialMesh")
		local offset = not specialMesh and Vector3.new(0, 0, 0) or specialMesh.Offset
		local result = {}

		for _, v11 in v10 or { v3 } do
			table.insert(result, {
				part = handle,
				offset = offset,
				normal = v11.normal,
				fullDegrees = v11.fullDegrees,
				zeroDegrees = v11.zeroDegrees,
				weight = v11.weight,
				target = accessory
			})
		end

		return result
	end
end

local ItemAnchors = {}

function ItemAnchors.findAppliedAccessory(instance, p: number)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local humanoidDescription = humanoid and humanoid:FindFirstChildOfClass("HumanoidDescription")

	if not humanoidDescription then
		return nil
	end

	for _, accessoryDescription in humanoidDescription:GetChildren() do
		if not (accessoryDescription:IsA("AccessoryDescription") and accessoryDescription.AssetId == p) then
			continue
		end

		local success, result = pcall(function()
			return accessoryDescription:GetAppliedInstance()
		end)

		if success and result then
			return result
		end
	end

	return nil
end

local function anchorsForAsset(instance, p: number, p2: number?, callback)
	local target = callback(p)

	if target then
		return (accessoryAnchors(instance, target))
	end

	if p2 == v5.Shirt then
		return regionAnchors(instance, "torso", { v, v2 }) -- inferred equivalent call
	elseif p2 == v5.TShirt then
		return regionAnchors(instance, "torso", { v }) -- inferred equivalent call
	elseif p2 == v5.Pants then
		return regionAnchors(instance, "legs", { v, v2 }) -- inferred equivalent call
	elseif p2 == v5.Face or p2 == v5.Head or p2 == v5.DynamicHead then
		return regionAnchors(instance, "head", { v }) -- inferred equivalent call
	else
		if p2 == v5.Gear then
			local tool = instance:FindFirstChildOfClass("Tool")
			local handle = tool and tool:FindFirstChild("Handle")

			if tool and handle and handle:IsA("BasePart") then
				return {
					{
						part = handle,
						offset = Vector3.new(0, 0, 0),
						normal = nil,
						fullDegrees = v3.fullDegrees,
						zeroDegrees = v3.zeroDegrees,
						weight = 1,
						target = tool
					}
				}
			end
		end

		return {}
	end
end

local function isBundlePartWorn(instance, id: number, assetType: number?): boolean -- 1 equivalent call inferred from this helper
	local v9

	if assetType then
		v9 = v6[assetType]
	end

	if not v9 then
		return true
	end

	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local humanoidDescription = humanoid and humanoid:FindFirstChildOfClass("HumanoidDescription")
	return humanoidDescription ~= nil and humanoidDescription[v9] == id
end

function ItemAnchors.resolve(instance, items, callback)
	local v9 = callback or function(p: number)
		return ItemAnchors.findAppliedAccessory(instance, p)
	end

	local result = {}

	for _, item in items do
		local id = item.id
		local v10 = tonumber(id)

		if not (id and v10) then
			continue
		end

		local anchors = {}

		if item.itemType == "Bundle" then
			for _, v11 in item.assetsInBundle or {} do
				local id2 = tonumber(v11.id)
				local assetType = tonumber(v11.assetType)

				if not (id2 and isBundlePartWorn(instance, id2, assetType)) then -- inferred equivalent call
					continue
				end

				for _, v12 in anchorsForAsset(instance, id2, assetType, v9) do
					table.insert(anchors, v12)
				end
			end
		else
			anchors = anchorsForAsset(instance, v10, tonumber(item.itemSubType), v9)
		end

		if #anchors > 0 then
			table.insert(result, { itemId = id, anchors = anchors })
		end
	end

	return result
end

return ItemAnchors
