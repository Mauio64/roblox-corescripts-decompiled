local MannequinUtility = {}

local InsertService = game:GetService("InsertService")

MannequinUtility.CharacterPartNames = {
	R6 = {
		HumanoidRootPart = true,
		Head = true,
		Torso = true,
		["Left Arm"] = true,
		["Left Leg"] = true,
		["Right Arm"] = true,
		["Right Leg"] = true,
		CharacterMesh = true
	},
	R15 = {
		HumanoidRootPart = true,
		Head = true,
		UpperTorso = true,
		LowerTorso = true,
		LeftUpperLeg = true,
		LeftLowerLeg = true,
		LeftFoot = true,
		RightUpperLeg = true,
		RightLowerLeg = true,
		RightFoot = true,
		LeftUpperArm = true,
		LeftLowerArm = true,
		LeftHand = true,
		RightUpperArm = true,
		RightLowerArm = true,
		RightHand = true
	}
}

MannequinUtility.R15PartNameToEnum = {
	Head = Enum.BodyPartR15.Head,
	UpperTorso = Enum.BodyPartR15.UpperTorso,
	LowerTorso = Enum.BodyPartR15.LowerTorso,
	LeftUpperLeg = Enum.BodyPartR15.LeftUpperLeg,
	LeftLowerLeg = Enum.BodyPartR15.LeftLowerLeg,
	LeftFoot = Enum.BodyPartR15.LeftFoot,
	RightUpperLeg = Enum.BodyPartR15.RightUpperLeg,
	RightLowerLeg = Enum.BodyPartR15.RightLowerLeg,
	RightFoot = Enum.BodyPartR15.RightFoot,
	LeftUpperArm = Enum.BodyPartR15.LeftUpperArm,
	LeftLowerArm = Enum.BodyPartR15.LeftLowerArm,
	LeftHand = Enum.BodyPartR15.LeftHand,
	RightUpperArm = Enum.BodyPartR15.RightUpperArm,
	RightLowerArm = Enum.BodyPartR15.RightLowerArm,
	RightHand = Enum.BodyPartR15.RightHand
}

MannequinUtility.CharacterPartNames.All = {}
local v = { R6 = true, R15 = true, R15ArtistIntent = true }

for k, _ in pairs(MannequinUtility.CharacterPartNames.R6) do
	MannequinUtility.CharacterPartNames.All[k] = true
end

for k, _ in pairs(MannequinUtility.CharacterPartNames.R15) do
	MannequinUtility.CharacterPartNames.All[k] = true
end

local function loadMannequin(p, flag: boolean?) -- 5 equivalent calls inferred from this helper
	local v2 = flag == nil or flag

	local mannequin = InsertService:LoadLocalAsset(p)
	local humanoid = mannequin:FindFirstChild("Humanoid")
	assert(humanoid, "Assert Humanoid is not nil to silence type checker")
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	if v2 then
		mannequin.Parent = workspace
	end

	return mannequin
end

function MannequinUtility.LoadR15Mannequin(flag: boolean?)
	return loadMannequin("rbxasset://models/Thumbnails/Mannequins/R15.rbxm", flag) -- inferred equivalent call
end

function MannequinUtility.LoadR6Mannequin(flag: boolean?)
	return loadMannequin("rbxasset://models/Thumbnails/Mannequins/R6.rbxm", flag) -- inferred equivalent call
end

function MannequinUtility.LoadRthroMannequin(flag: boolean?)
	return loadMannequin("rbxasset://models/Thumbnails/Mannequins/Rthro.rbxm", flag) -- inferred equivalent call
end

function MannequinUtility.LoadR15PlusMannequin(flag: boolean?)
	if game:GetEngineFeature("R15PlusMannequinContent") then
		return loadMannequin("rbxasset://models/Thumbnails/Mannequins/R15-plus.rbxm", flag) -- inferred equivalent call
	end

	return loadMannequin("rbxasset://models/Thumbnails/Mannequins/R15.rbxm", flag) -- inferred equivalent call
end

function MannequinUtility.LoadMannequinForScaleType(p, flag: boolean?)
	if p == "Classic" then
		return MannequinUtility.LoadR15Mannequin(flag)
	end

	return MannequinUtility.LoadRthroMannequin(flag)
end

function MannequinUtility.AssertObjectsFormat(items)
	local v2 = false

	for _, folder in items do
		assert(folder:IsA("Folder"), "object should always be a Folder")

		if not v[folder.Name] then
			continue
		end

		v2 = true

		for _, child in folder:GetChildren() do
			assert(
				MannequinUtility.CharacterPartNames.All[child.Name],
				string.format("Name of %s of Folder %s does not exist in CharacterParts", child.Name, folder.Name)
			)
		end
	end

	assert(v2, "objects does not have at least one of R15ArtistIntent, R15, and R6 folders")
end

function MannequinUtility.CreateBodyPartMannequin(items, flag: boolean?)
	MannequinUtility.AssertObjectsFormat(items)
	local v2 = "Classic"
	local v3 = false
	local flag2 = false

	for _, item in items do
		if item.Name == "R15" or item.Name == "R15ArtistIntent" then
			flag2 = true

			local avatarPartScaleType = item:FindFirstChild("AvatarPartScaleType", true)

			if avatarPartScaleType then
				v2 = avatarPartScaleType.Value
			end

			break
		end
	end

	for _, item in items do
		if item.Name == "R15ArtistIntent" then
			v3 = true
			break
		end
	end

	local v4

	if flag2 then
		v4 = MannequinUtility.LoadMannequinForScaleType(v2, flag)
	else
		v4 = MannequinUtility.LoadR6Mannequin(flag)
	end

	local humanoid = v4:FindFirstChildOfClass("Humanoid")

	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	local bodyTypeScale = humanoid:FindFirstChild("BodyTypeScale")

	if bodyTypeScale == nil then
		bodyTypeScale = Instance.new("NumberValue")
		bodyTypeScale.Name = "BodyTypeScale"
		bodyTypeScale.Value = 0
		bodyTypeScale.Parent = humanoid
	end

	local bodyProportionScale = humanoid:FindFirstChild("BodyProportionScale")

	if bodyProportionScale == nil then
		bodyProportionScale = Instance.new("NumberValue")
		bodyProportionScale.Name = "BodyProportionScale"
		bodyProportionScale.Value = 0
		bodyProportionScale.Parent = humanoid
	end

	if v2 == "ProportionsNormal" then
		bodyTypeScale.Value = 1
		bodyProportionScale.Value = 0
	elseif v2 == "ProportionsSlender" then
		bodyTypeScale.Value = 1
		bodyProportionScale.Value = 1
	end

	return flag2, v3, v4
end

function MannequinUtility.SetupBodyPartMannequin(flag: boolean, flag2: boolean, parent, items, p: string?)
	MannequinUtility.AssertObjectsFormat(items)
	local v2 = false

	if p then
		local objects = game:GetObjects(p)
		objects[1].Parent = parent
	end

	local function addFolderChildren(item, names, parts)
		for _, part in pairs(item:GetChildren()) do
			assert(part:IsA("BasePart"), "Only BaseParts should be in Folders")

			if string.find(part.Name, "Right") then
				v2 = true
			end

			parent:FindFirstChild("Humanoid"):ReplaceBodyPartR15(MannequinUtility.R15PartNameToEnum[part.Name], part)
			table.insert(names, part.Name)
			table.insert(parts, part)
		end
	end

	local v3 = flag and flag2 and "R15ArtistIntent" or "R15"
	local v4 = {}
	local v5 = {}

	for _, item in pairs(items) do
		if flag and item.Name == v3 or not flag and item.Name == "R6" then
			addFolderChildren(item, v4, v5)
		elseif not string.find(item.Name, "R15") then
			item.Parent = parent
		end
	end

	if not flag then
		return v2, v4
	end

	local humanoidRootPart = parent:FindFirstChild("HumanoidRootPart")
	parent.PrimaryPart = humanoidRootPart
	humanoidRootPart.CFrame = CFrame.new(Vector3.new(0, 5, 0)) * CFrame.Angles(0, 3.141592653589793, 0)
	humanoidRootPart.Anchored = true
	parent:FindFirstChildOfClass("Humanoid"):BuildRigFromAttachments()

	return v2, v4
end

function MannequinUtility:CreateHeadModel()
	local model = Instance.new("Model")

	self.Name = "Head"
	self.Parent = model

	local humanoid = Instance.new("Humanoid")
	humanoid.RigType = Enum.HumanoidRigType.R15
	humanoid.Parent = model

	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	return model
end

return MannequinUtility
