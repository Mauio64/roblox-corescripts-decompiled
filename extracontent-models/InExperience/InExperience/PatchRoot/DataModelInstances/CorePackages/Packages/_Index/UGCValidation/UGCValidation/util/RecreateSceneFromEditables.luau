local parent = script.Parent.Parent
require(parent.util.Types)
local AssetService = game:GetService("AssetService")
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local R15plusUtils = require(parent.util.R15plusUtils)
local RigBuilder = require(parent.util.RigBuilder)
local buildEmoteKeyframeSequenceFromCurveAnim = require(parent.util.buildEmoteKeyframeSequenceFromCurveAnim)

local getEngineFeatureEngineUGCValidateEmoteAnimationExport = require(parent.flags.getEngineFeatureEngineUGCValidateEmoteAnimationExport)

local RecreateSceneFromEditables = {}

RecreateSceneFromEditables.requiredData = {
	ValidationEnums.SharedDataMember.renderMeshesData,
	ValidationEnums.SharedDataMember.innerCagesData,
	ValidationEnums.SharedDataMember.outerCagesData,
	ValidationEnums.SharedDataMember.meshTextures
}

local function createCagePart(p, p2, p3, p4: string)
	local meshPartAsync = AssetService:CreateMeshPartAsync(Content.fromObject(p3.editable))
	meshPartAsync.Name = `{p}_{p4}`
	meshPartAsync.Size *= p2.scale
	local v = CFrame.new(p3.origin.Position * p2.scale) * p3.origin.Rotation
	meshPartAsync.CFrame = p.CFrame * v
	return meshPartAsync
end

local function copyMeshPart(part, p, meshTexture)
	local meshPartAsync = AssetService:CreateMeshPartAsync(Content.fromObject(p.editable))

	if meshTexture and not meshTexture.isPBR and meshTexture.Texture then
		meshPartAsync.TextureContent = Content.fromObject(meshTexture.Texture.editable)
	elseif meshTexture and meshTexture.isPBR then
		local surfaceAppearance = Instance.new("SurfaceAppearance")

		if meshTexture.ColorMap then
			surfaceAppearance.ColorMapContent = Content.fromObject(meshTexture.ColorMap.editable)
		end

		if meshTexture.MetalnessMap then
			surfaceAppearance.MetalnessMapContent = Content.fromObject(meshTexture.MetalnessMap.editable)
		end

		if meshTexture.NormalMap then
			surfaceAppearance.NormalMapContent = Content.fromObject(meshTexture.NormalMap.editable)
		end

		if meshTexture.RoughnessMap then
			surfaceAppearance.RoughnessMapContent = Content.fromObject(meshTexture.RoughnessMap.editable)
		end

		if meshTexture.EmissiveMask then
			surfaceAppearance.EmissiveMaskContent = Content.fromObject(meshTexture.EmissiveMask.editable)
		end

		surfaceAppearance.Parent = meshPartAsync
	end

	meshPartAsync.Name = part.Name
	meshPartAsync.Size = part.Size
	meshPartAsync.CFrame = part.CFrame

	for _, child in part:GetChildren() do
		if
			not (child:IsA("Attachment") or child:IsA("FaceControls"))
			or R15plusUtils.checkFlagEnabledForAllowHrd() and child:IsA("Bone")
		then
			continue
		end

		local clone = child:Clone()
		clone.Parent = meshPartAsync
	end

	if not R15plusUtils.checkFlagEnabledForAllowHrd() then
		return meshPartAsync
	end

	local avatarBoneSchema = R15plusUtils.getAvatarBoneSchema(part.Name)
	local nameWhitelistOfClassInSchema = R15plusUtils.getNameWhitelistOfClassInSchema(avatarBoneSchema, "Attachment")

	for childName, v in nameWhitelistOfClassInSchema do
		if not (v and meshPartAsync:FindFirstChild(childName) == nil) then
			continue
		end

		local child = part:FindFirstChild(childName, true)
		local worldCFrame

		if child == nil then
			worldCFrame = meshPartAsync.CFrame
		else
			worldCFrame = child.WorldCFrame
		end

		local attachment = Instance.new("Attachment")
		attachment.Name = childName
		attachment.Parent = meshPartAsync
		attachment.WorldCFrame = worldCFrame
	end

	return meshPartAsync
end

local function addBonesFromPoses(instance, humanoidRootPart, defaultCharacter)
	for _, pose in instance:GetChildren() do
		if not pose:IsA("Pose") then
			continue
		end

		local name = pose.Name
		local part = defaultCharacter:FindFirstChild(name)

		if part and part:IsA("BasePart") then
			addBonesFromPoses(pose, part, defaultCharacter)
		else
			local bone = Instance.new("Bone")
			bone.Name = name
			bone.Parent = humanoidRootPart
			addBonesFromPoses(pose, bone, defaultCharacter)
		end
	end
end

local function createEmoteExportScene(data)
	local defaultCharacter = RigBuilder.createDefaultCharacter(false)
	local v

	if data.curveAnimations and #data.curveAnimations > 0 then
		v = buildEmoteKeyframeSequenceFromCurveAnim(data.curveAnimations[1])
	end

	if not v then
		error("Emote export requires a curve animation, but none was available")
	end

	v.Parent = defaultCharacter

	local children = v:GetChildren()
	local humanoidRootPart = defaultCharacter:FindFirstChild("HumanoidRootPart")

	if #children > 0 and humanoidRootPart and humanoidRootPart:IsA("BasePart") then
		addBonesFromPoses(children[1], humanoidRootPart, defaultCharacter)
	end

	defaultCharacter:PivotTo(CFrame.new())
	return defaultCharacter
end

function RecreateSceneFromEditables.createModelForGltfExport(data)
	if
		getEngineFeatureEngineUGCValidateEmoteAnimationExport()
		and data.uploadCategory == ValidationEnums.UploadCategory.EMOTE_ANIMATION
	then
		return createEmoteExportScene(data)
	end

	local model = Instance.new("Model")
	local descendants = data.rootInstance:GetDescendants()
	table.insert(descendants, data.rootInstance)

	for _, part in descendants do
		if not part:IsA("MeshPart") then
			continue
		end

		local name = part.Name
		local v = data.renderMeshesData[name]

		if not v then
			error("Missing editable data")
		end

		local v2 = copyMeshPart(part, v, data.meshTextures[name])
		v2.Parent = model

		local v3 = data.outerCagesData[name]

		if v3 then
			local cagePart = createCagePart(v2, v, v3, "OuterCage")
			cagePart.Parent = model
		end

		local v4 = data.innerCagesData[name]

		if v4 then
			local cagePart = createCagePart(v2, v, v4, "InnerCage")
			cagePart.Parent = model
		end

		if data.uploadCategory == ValidationEnums.UploadCategory.FULL_BODY then
			v2.Name = `{name}_Geo`
		end
	end

	model:PivotTo(CFrame.new())
	return model
end

return RecreateSceneFromEditables
