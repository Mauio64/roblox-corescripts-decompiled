local CollectionService = game:GetService("CollectionService")
local v2 = game:DefineFastFlag("SelfViewNeckCheck", false)
local t1 = {
	Accessory = "Accessory",
	CharacterMesh = "CharacterMesh",
	Decal = "Decal",
	MeshPart = "MeshPart",
	Pants = "Pants",
	Part = "Part",
	Shirt = "Shirt",
	ShirtGraphic = "ShirtGraphic",
	SpecialMesh = "SpecialMesh",
	SurfaceAppearance = "SurfaceAppearance"
}

local function findObjectOfNameAndTypeName(s1: string, s2: string, p1) -- line: 72
	if p1 == nil then
		return nil
	end

	for _, descendant in (p1:GetDescendants()) do
		if descendant:IsA(s2) and s1 == descendant.Name then
			return descendant
		end
	end

	return nil
end
local function getHead(p2) -- line: 85
	-- upvalues: findObjectOfNameAndTypeName (copy)
	if not p2 then
		return nil
	end

	local Parent = nil
	local v30 = if p2 ~= nil then p2:FindFirstChildWhichIsA("FaceControls", true) else nil

	if v30 ~= nil and v30.Parent and (v30.Parent.ClassName == "MeshPart" or v30.Parent.ClassName == "Part") then
		Parent = v30.Parent
	end

	if not Parent then
		Parent = findObjectOfNameAndTypeName("Head", "MeshPart", p2)
	end

	if not Parent then
		Parent = findObjectOfNameAndTypeName("Head", "Part", p2)
	end

	return Parent
end
local function getAnimator(p3, n1: number) -- line: 118
	local v33 = nil
	local v35

	if n1 > 0 then
		local Humanoid = p3:WaitForChild("Humanoid", n1)

		v35 = if not Humanoid then p3:FindFirstChildWhichIsA("Humanoid") else if not Humanoid:IsA("Humanoid") then p3:FindFirstChildWhichIsA("Humanoid") else Humanoid
	else
		v35 = p3:FindFirstChildWhichIsA("Humanoid")
	end

	if v35 ~= nil then
		v33 = if not (n1 > 0) then v35:FindFirstChild("Animator") else v35:WaitForChild("Animator", n1)
	end

	if v33 == nil then
		v33 = p3:FindFirstChildWhichIsA("Animator", true)
	end

	return v33
end

local t2 = {
	"Head",
	"UpperTorso",
	"LowerTorso",
	"Torso",
	"LeftFoot",
	"LeftLowerLeg",
	"LeftUpperLeg",
	"RightFoot",
	"RightLowerLeg",
	"RightUpperLeg",
	"LeftHand",
	"LeftLowerArm",
	"LeftUpperArm",
	"RightHand",
	"RightLowerArm",
	"RightUpperArm"
}

local function removeChild(p4, s3: string) -- line: 223
	local s3_2 = p4:FindFirstChild(s3)

	if s3_2 then
		s3_2:Destroy()
	end
end

local t3 = {
	Accessory = "Accessory",
	Animator = "Animator",
	Attachment = "Attachment",
	AnimationConstraint = "AnimationConstraint",
	BallSocketConstraint = "BallSocketConstraint",
	BodyColors = "BodyColors",
	Bone = "Bone",
	CharacterMesh = "CharacterMesh",
	Decal = "Decal",
	DigitsRigDescription = "DigitsRigDescription",
	FaceControls = "FaceControls",
	Humanoid = "Humanoid",
	HumanoidDescription = "HumanoidDescription",
	HumanoidRigDescription = "HumanoidRigDescription",
	MeshPart = "MeshPart",
	Motor6D = "Motor6D",
	NumberValue = "NumberValue",
	Pants = "Pants",
	Part = "Part",
	Shirt = "Shirt",
	ShirtGraphic = "ShirtGraphic",
	SpecialMesh = "SpecialMesh",
	StringValue = "StringValue",
	SurfaceAppearance = "SurfaceAppearance",
	Vector3Value = "Vector3Value",
	WrapTarget = "WrapTarget",
	Weld = "Weld",
	WrapLayer = "WrapLayer",
	WeldConstraint = "WeldConstraint",
	AccessoryWeld = "AccessoryWeld",
	PackageLink = "PackageLink",
	Folder = "Folder",
	RigidConstraint = "RigidConstraint",
	WrapTextureTransfer = "WrapTextureTransfer"
}

local function disableScripts(p5) -- line: 298
	-- upvalues: disableScripts (copy)
	for _, child in p5:GetChildren() do
		if child:IsA("Script") then
			child.Disabled = true
			child.Parent = nil
		end

		disableScripts(child)
	end
end
local function removeUI(p6) -- line: 308
	-- upvalues: removeUI (copy)
	for _, child in p6:GetChildren() do
		if child:IsA("GuiObject") or child:IsA("ScreenGui") or child:IsA("BillboardGui") or child:IsA("AdGui") or child:IsA("SurfaceGui") then
			child.Parent = nil
		end

		removeUI(child)
	end
end
local function removeInstancesStrict(p7) -- line: 323
	-- upvalues: t3 (copy), removeInstancesStrict (copy)
	for _, child in p7:GetChildren() do
		if not t3[child.ClassName] then
			child.Parent = nil
		end

		removeInstancesStrict(child)
	end
end

return {
	getFaceControls = function(p8) -- line: 24
		if p8 == nil then
			return
		end

		return (p8:FindFirstChildWhichIsA("FaceControls", true))
	end,
	getNeck = function(p9, p10) -- line: 31
		-- upvalues: v2 (copy)
		if p9 == nil or p10 == nil then
			return nil
		end

		local descendants = p9:GetDescendants()

		for _, v18 in descendants do
			if v18:IsA("Motor6D") and (p10 == v18.Part1 or v18.Name == "Neck") then
				return v18
			end
		end

		if v2 == true then
			for _, v20 in descendants do
				if v20:IsA("AnimationConstraint") and p10 == v20.Parent and (v20.Attachment0 ~= nil and v20.Attachment0.Name == "NeckRigAttachment" or v20.Name == "Neck") then
					return v20
				end
			end
		else
			for _, v22 in descendants do
				if v22:IsA("AnimationConstraint") and p10 == v22.Parent and (v22.Attachment0.Name == "NeckRigAttachment" or v22.Name == "Neck") then
					return v22
				end
			end
		end

		return nil
	end,
	getHead = getHead,
	getAnimator = getAnimator,
	updateTransparency = function(p11, p12) -- line: 172
		-- upvalues: t2 (copy), CollectionService (copy)
		for _, descendant in ipairs(p11:GetDescendants()) do
			if descendant:IsA("Decal") then
				descendant.Transparency = 0
			elseif descendant:IsA("MeshPart") then
				if descendant.Parent and descendant.Parent:IsA("Accessory") or table.find(t2, descendant.Name) then
					if not table.find(p12, descendant.MeshId) then
						p12[descendant.MeshId] = descendant.Transparency
					else
						descendant.Transparency = p12[descendant.MeshId]
					end
				end
			elseif descendant:IsA("Part") then
				if descendant.Parent and descendant.Parent:IsA("Accessory") or table.find(t2, descendant.Name) then
					descendant.Transparency = 0
				end

				if CollectionService:HasTag(descendant, "__RBX__LOCKED_TRANSPARENT") then
					descendant.Transparency = 1
				end
			end
		end
	end,
	shouldMarkCloneDirtyForDescendant = function(p13) -- line: 201
		-- upvalues: t1 (copy)
		if p13:IsA("MeshPart") or (p13:IsA("Part") or p13:IsA("Decal")) then
			if p13.Transparency < 1 then
				return true
			end
		elseif t1[p13.ClassName] then
			return true
		end

		return false
	end,
	resetPartOrientation = function(p14) -- line: 214
		for _, descendant in ipairs(p14:GetDescendants()) do
			if descendant:IsA("Motor6D") then
				descendant.C0 = CFrame.new(descendant.C0.Position)
				descendant.C1 = CFrame.new(descendant.C1.Position)
			end
		end
	end,
	removeScripts = function(p15) -- line: 229
		local Animate = p15:FindFirstChild("Animate")

		if Animate then
			Animate:Destroy()
		end

		local Health = p15:FindFirstChild("Health")

		if Health then
			Health:Destroy()
		end

		for _, descendant in pairs(p15:GetDescendants()) do
			if descendant:IsA("BaseScript") then
				descendant:Destroy()
			end
		end
	end,
	removeTags = function(p16) -- line: 240
		-- upvalues: CollectionService (copy)
		local Tags = CollectionService:GetTags(p16)

		for _, v in ipairs(Tags) do
			if v ~= "NoFace" then
				CollectionService:RemoveTag(p16, v)
			end
		end

		for _, descendant in ipairs(p16:GetDescendants()) do
			local Tags2 = CollectionService:GetTags(descendant)

			for _, v in ipairs(Tags2) do
				if v ~= "NoFace" then
					CollectionService:RemoveTag(descendant, v)
				end
			end
		end

		CollectionService:GetTags(p16)
	end,
	sanitizeCharacter = function(p17) -- line: 332
		-- upvalues: removeInstancesStrict (copy)
		if not p17 then
			return
		end

		removeInstancesStrict(p17)
	end,
	isValidAvatar = function(p18) -- line: 340
		-- upvalues: getAnimator (copy), getHead (copy)
		if not getAnimator(p18, 10) then
			return false
		end

		if not getHead(p18) then
			return false
		end

		return true
	end,
	hasDynamicHead = function(p19) -- line: 354
		return ((if p19 ~= nil then p19:FindFirstChildWhichIsA("FaceControls", true) else nil)) ~= nil
	end
}
