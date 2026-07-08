local t1 = {}
local InsertService = game:GetService("InsertService")
local t2 = {
	R6 = true,
	R15 = true,
	R15ArtistIntent = true
}

t1.CharacterPartNames = {
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
t1.R15PartNameToEnum = {
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
t1.CharacterPartNames.All = {}

for k, _ in pairs(t1.CharacterPartNames.R6) do
	t1.CharacterPartNames.All[k] = true
end

for k, _ in pairs(t1.CharacterPartNames.R15) do
	t1.CharacterPartNames.All[k] = true
end

local function loadMannequin(p1, b1: boolean?) -- line: 95
	-- upvalues: InsertService (copy)
	if b1 == nil then
		b1 = true
	end

	local v11 = InsertService:LoadLocalAsset(p1)
	local Humanoid = v11:FindFirstChild("Humanoid")

	assert(Humanoid, "Assert Humanoid is not nil to silence type checker")
	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	if b1 then
		v11.Parent = workspace
	end

	return v11
end

function t1.LoadR15Mannequin(b2: boolean?) -- line: 112
	-- upvalues: InsertService (copy)
	if b2 == nil then
		b2 = true
	end

	local v14 = InsertService:LoadLocalAsset("rbxasset://models/Thumbnails/Mannequins/R15.rbxm")
	local Humanoid = v14:FindFirstChild("Humanoid")

	assert(Humanoid, "Assert Humanoid is not nil to silence type checker")
	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	if b2 then
		v14.Parent = workspace
	end

	return v14
end
function t1.LoadR6Mannequin(b3: boolean?) -- line: 116
	-- upvalues: InsertService (copy)
	if b3 == nil then
		b3 = true
	end

	local v17 = InsertService:LoadLocalAsset("rbxasset://models/Thumbnails/Mannequins/R6.rbxm")
	local Humanoid = v17:FindFirstChild("Humanoid")

	assert(Humanoid, "Assert Humanoid is not nil to silence type checker")
	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	if b3 then
		v17.Parent = workspace
	end

	return v17
end
function t1.LoadRthroMannequin(b4: boolean?) -- line: 120
	-- upvalues: InsertService (copy)
	if b4 == nil then
		b4 = true
	end

	local v20 = InsertService:LoadLocalAsset("rbxasset://models/Thumbnails/Mannequins/Rthro.rbxm")
	local Humanoid = v20:FindFirstChild("Humanoid")

	assert(Humanoid, "Assert Humanoid is not nil to silence type checker")
	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	if b4 then
		v20.Parent = workspace
	end

	return v20
end
function t1.LoadR15PlusMannequin(b5: boolean?) -- line: 124
	-- upvalues: InsertService (copy)
	if game:GetEngineFeature("R15PlusMannequinContent") then
		if b5 == nil then
			b5 = true
		end

		local v23 = InsertService:LoadLocalAsset("rbxasset://models/Thumbnails/Mannequins/R15-plus.rbxm")
		local Humanoid = v23:FindFirstChild("Humanoid")

		assert(Humanoid, "Assert Humanoid is not nil to silence type checker")
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

		if b5 then
			v23.Parent = workspace
		end

		return v23
	end

	if b5 == nil then
		b5 = true
	end

	local v25 = InsertService:LoadLocalAsset("rbxasset://models/Thumbnails/Mannequins/R15.rbxm")
	local Humanoid = v25:FindFirstChild("Humanoid")

	assert(Humanoid, "Assert Humanoid is not nil to silence type checker")
	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	if b5 then
		v25.Parent = workspace
	end

	return v25
end
function t1.LoadMannequinForScaleType(p2, b6: boolean?) -- line: 131
	-- upvalues: t1 (copy)
	if p2 == "Classic" then
		return t1.LoadR15Mannequin(b6)
	end

	return t1.LoadRthroMannequin(b6)
end
function t1.AssertObjectsFormat(t3: {[any]: any}) -- line: 144
	-- upvalues: t2 (copy), t1 (copy)
	local v30 = false

	for _, v32 in t3 do
		assert(v32:IsA("Folder"), "object should always be a Folder")

		if t2[v32.Name] then
			v30 = true

			for _, child in v32:GetChildren() do
				assert(t1.CharacterPartNames.All[child.Name], string.format("Name of %s of Folder %s does not exist in CharacterParts", child.Name, v32.Name))
			end
		end
	end

	assert(v30, "objects does not have at least one of R15ArtistIntent, R15, and R6 folders")
end
function t1.CreateBodyPartMannequin(t4: {[any]: any}, b7: boolean?) -- line: 175
	-- upvalues: t1 (copy)
	local v37 = false
	local v38 = false
	local s1 = "Classic"

	t1.AssertObjectsFormat(t4)

	for _, v41 in t4 do
		if v41.Name == "R15" or v41.Name == "R15ArtistIntent" then
			v37 = true

			local AvatarPartScaleType = v41:FindFirstChild("AvatarPartScaleType", true)

			if not AvatarPartScaleType then
				break
			end

			s1 = AvatarPartScaleType.Value

			break
		end
	end

	for _, v44 in t4 do
		if v44.Name == "R15ArtistIntent" then
			v38 = true

			break
		end
	end

	local v45 = if not v37 then t1.LoadR6Mannequin(b7) else t1.LoadMannequinForScaleType(s1, b7)
	local Humanoid = v45:FindFirstChildOfClass("Humanoid")

	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	local BodyTypeScale = Humanoid:FindFirstChild("BodyTypeScale")

	if BodyTypeScale == nil then
		BodyTypeScale = Instance.new("NumberValue")
		BodyTypeScale.Name = "BodyTypeScale"
		BodyTypeScale.Value = 0
		BodyTypeScale.Parent = Humanoid
	end

	local BodyProportionScale = Humanoid:FindFirstChild("BodyProportionScale")

	if BodyProportionScale == nil then
		BodyProportionScale = Instance.new("NumberValue")
		BodyProportionScale.Name = "BodyProportionScale"
		BodyProportionScale.Value = 0
		BodyProportionScale.Parent = Humanoid
	end

	if s1 == "ProportionsNormal" then
		BodyTypeScale.Value = 1
		BodyProportionScale.Value = 0
	elseif s1 == "ProportionsSlender" then
		BodyTypeScale.Value = 1
		BodyProportionScale.Value = 1
	end

	return v37, v38, v45
end
function t1.SetupBodyPartMannequin(b8: boolean, b9: boolean, p3, t5: {[any]: any}, s2: string?) -- line: 257
	-- upvalues: t1 (copy)
	t1.AssertObjectsFormat(t5)

	local u54 = false

	if s2 then
		game:GetObjects(s2)[1].Parent = p3
	end

	local function addFolderChildren(p4, t6: {[any]: any}, t7: {[any]: any}) -- line: 272
		-- upvalues: u54 (ref), p3 (copy), t1 (copy)
		for _, child in pairs(p4:GetChildren()) do
			assert(child:IsA("BasePart"), "Only BaseParts should be in Folders")

			if string.find(child.Name, "Right") then
				u54 = true
			end

			p3:FindFirstChild("Humanoid"):ReplaceBodyPartR15(t1.R15PartNameToEnum[child.Name], child)
			table.insert(t6, child.Name)
			table.insert(t7, child)
		end
	end

	local s3 = "R15"

	if b8 and b9 then
		s3 = "R15ArtistIntent"
	end

	local t8 = {}

	for _, v in pairs(t5) do
		if b8 and s3 == v.Name or not b8 and v.Name == "R6" then
			addFolderChildren(v, t8, {})
		elseif not string.find(v.Name, "R15") then
			v.Parent = p3
		end
	end

	if b8 then
		local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart")

		p3.PrimaryPart = HumanoidRootPart
		HumanoidRootPart.CFrame = CFrame.new((Vector3.new(0, 5, 0))) * CFrame.Angles(0, 3.141592653589793, 0)
		HumanoidRootPart.Anchored = true
		p3:FindFirstChildOfClass("Humanoid"):BuildRigFromAttachments()
	end

	return u54, t8
end
function t1.CreateHeadModel(p5) -- line: 322
	local Model = Instance.new("Model")

	p5.Name = "Head"
	p5.Parent = Model

	local Humanoid = Instance.new("Humanoid")

	Humanoid.RigType = Enum.HumanoidRigType.R15
	Humanoid.Parent = Model
	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	return Model
end

return t1
