local CollectionService = game:GetService("CollectionService")

local v = {
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

local function getFaceControls(instance) -- 2 equivalent calls inferred from this helper
	if instance == nil then
		return
	end

	return (instance:FindFirstChildWhichIsA("FaceControls", true))
end

local function findObjectOfNameAndTypeName(p: string, className: string, folder)
	if folder == nil then
		return nil
	end

	local descendants = folder:GetDescendants()

	for _, descendant in descendants do
		if descendant:IsA(className) and descendant.Name == p then
			return descendant
		end
	end

	return nil
end

local function getHead(instance)
	if not instance then
		return nil
	end

	local parent = nil
	local faceControls = getFaceControls(instance) -- inferred equivalent call

	if
		faceControls ~= nil
		and faceControls.Parent
		and (faceControls.Parent.ClassName == "MeshPart" or faceControls.Parent.ClassName == "Part")
	then
		parent = faceControls.Parent
	end

	return parent
		or findObjectOfNameAndTypeName("Head", "MeshPart", instance)
		or findObjectOfNameAndTypeName("Head", "Part", instance)
end

local function getAnimator(instance, p: number)
	local animator = nil
	local humanoid

	if p > 0 then
		humanoid = instance:WaitForChild("Humanoid", p)

		if humanoid then
			if not humanoid:IsA("Humanoid") then
				humanoid = instance:FindFirstChildWhichIsA("Humanoid")
			end
		else
			humanoid = instance:FindFirstChildWhichIsA("Humanoid")
		end
	else
		humanoid = instance:FindFirstChildWhichIsA("Humanoid")
	end

	if humanoid ~= nil then
		if p > 0 then
			animator = humanoid:WaitForChild("Animator", p)
		else
			animator = humanoid:FindFirstChild("Animator")
		end
	end

	if animator == nil then
		animator = instance:FindFirstChildWhichIsA("Animator", true)
	end

	return animator
end

local v2 = {
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

local function removeChild(folder, childName: string) -- 2 equivalent calls inferred from this helper
	local child = folder:FindFirstChild(childName)

	if child then
		child:Destroy()
	end
end

local v3 = {
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
local function disableScripts(Script)
	for _, Script2 in Script:GetChildren() do
		if Script2:IsA("Script") then
			Script2.Disabled = true
			Script2.Parent = nil
		end

		disableScripts(Script2)
	end
end

local function removeUI(child)
	for _, child2 in child:GetChildren() do
		if
			child2:IsA("GuiObject")
			or child2:IsA("ScreenGui")
			or child2:IsA("BillboardGui")
			or child2:IsA("AdGui")
			or child2:IsA("SurfaceGui")
		then
			child2.Parent = nil
		end

		removeUI(child2)
	end
end

local function removeInstancesStrict(instance)
	for _, child in instance:GetChildren() do
		if not v3[child.ClassName] then
			child.Parent = nil
		end

		removeInstancesStrict(child)
	end
end

local ModelUtils = {}
ModelUtils.getFaceControls = getFaceControls

function ModelUtils.getNeck(folder, p)
	if folder == nil or p == nil then
		return nil
	end

	local descendants = folder:GetDescendants()

	for _, motor6D in descendants do
		if motor6D:IsA("Motor6D") and (motor6D.Part1 == p or motor6D.Name == "Neck") then
			return motor6D
		end
	end

	for _, animationConstraint in descendants do
		if
			animationConstraint:IsA("AnimationConstraint")
			and animationConstraint.Parent == p
			and (animationConstraint.Attachment0 ~= nil and animationConstraint.Attachment0.Name == "NeckRigAttachment" or animationConstraint.Name == "Neck")
		then
			return animationConstraint
		end
	end

	return nil
end

ModelUtils.getHead = getHead
ModelUtils.getAnimator = getAnimator

function ModelUtils.updateTransparency(folder, transparenciesByMeshId)
	for _, descendant in ipairs(folder:GetDescendants()) do
		if descendant:IsA("Decal") then
			descendant.Transparency = 0
		elseif descendant:IsA("MeshPart") then
			if descendant.Parent and descendant.Parent:IsA("Accessory") or table.find(v2, descendant.Name) then
				if table.find(transparenciesByMeshId, descendant.MeshId) then
					descendant.Transparency = transparenciesByMeshId[descendant.MeshId]
				else
					transparenciesByMeshId[descendant.MeshId] = descendant.Transparency
				end
			end
		elseif descendant:IsA("Part") then
			if descendant.Parent and descendant.Parent:IsA("Accessory") or table.find(v2, descendant.Name) then
				descendant.Transparency = 0
			end

			if CollectionService:HasTag(descendant, "__RBX__LOCKED_TRANSPARENT") then
				descendant.Transparency = 1
			end
		end
	end
end

function ModelUtils.shouldMarkCloneDirtyForDescendant(instance): boolean
	if instance:IsA("MeshPart") or instance:IsA("Part") or instance:IsA("Decal") then
		if instance.Transparency < 1 then
			return true
		end
	elseif v[instance.ClassName] then
		return true
	end

	return false
end

function ModelUtils.resetPartOrientation(folder)
	for _, motor6D in ipairs(folder:GetDescendants()) do
		if not motor6D:IsA("Motor6D") then
			continue
		end

		motor6D.C0 = CFrame.new(motor6D.C0.Position)
		motor6D.C1 = CFrame.new(motor6D.C1.Position)
	end
end

function ModelUtils.removeScripts(folder)
	removeChild(folder, "Animate") -- inferred equivalent call
	removeChild(folder, "Health") -- inferred equivalent call

	for _, baseScript in pairs(folder:GetDescendants()) do
		if baseScript:IsA("BaseScript") then
			baseScript:Destroy()
		end
	end
end

function ModelUtils.removeTags(folder)
	local tags = CollectionService:GetTags(folder)

	for _, tag in ipairs(tags) do
		if tag ~= "NoFace" then
			CollectionService:RemoveTag(folder, tag)
		end
	end

	for _, instance in ipairs(folder:GetDescendants()) do
		local tags2 = CollectionService:GetTags(instance)

		for _, tag in ipairs(tags2) do
			if tag ~= "NoFace" then
				CollectionService:RemoveTag(instance, tag)
			end
		end
	end

	CollectionService:GetTags(folder)
end

function ModelUtils.sanitizeCharacter(p)
	if not p then
		return
	end

	removeInstancesStrict(p)
end

function ModelUtils.isValidAvatar(p): boolean
	if not getAnimator(p, 10) then
		return false
	end

	return if getHead(p) then true else false
end

function ModelUtils.hasDynamicHead(instance): boolean
	return getFaceControls(instance) ~= nil -- inferred equivalent call
end

return ModelUtils
