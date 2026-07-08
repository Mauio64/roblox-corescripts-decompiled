local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local AssetService = game:GetService("AssetService")
local getFFlagUGCValidationAddPBRToSharedData = require(ParentParent.flags.getFFlagUGCValidationAddPBRToSharedData)
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getFFlagUGCValidationAddGeometryToExports = require(ParentParent.flags.getFFlagUGCValidationAddGeometryToExports)
local getFFlagUGCValidateAllowEmissives = require(ParentParent.flags.getFFlagUGCValidateAllowEmissives)
local t1 = {}

local function createCagePart(p1, p2, p3, s1: string) -- line: 18
	-- upvalues: AssetService (copy)
	local v15 = AssetService:CreateMeshPartAsync(Content.fromObject(p3.editable))

	v15.Name = `{ p1 }_{ s1 }`
	v15.Size = v15.Size * p2.scale

	local v16 = CFrame.new(p3.origin.Position * p2.scale) * p3.origin.Rotation

	v15.CFrame = p1.CFrame * v16

	return v15
end
local function copyMeshPart(p4, p5, p6) -- line: 32
	-- upvalues: AssetService (copy), getFFlagUGCValidationAddPBRToSharedData (copy), getFFlagUGCValidateAllowEmissives (copy), R15plusUtils (copy)
	local v20 = AssetService:CreateMeshPartAsync(Content.fromObject(p5.editable))

	if getFFlagUGCValidationAddPBRToSharedData() then
		if p6 and not p6.isPBR and p6.Texture then
			v20.TextureContent = Content.fromObject(p6.Texture.editable)
		elseif p6 and p6.isPBR then
			local SurfaceAppearance = Instance.new("SurfaceAppearance")

			if p6.ColorMap then
				SurfaceAppearance.ColorMapContent = Content.fromObject(p6.ColorMap.editable)
			end

			if p6.MetalnessMap then
				SurfaceAppearance.MetalnessMapContent = Content.fromObject(p6.MetalnessMap.editable)
			end

			if p6.NormalMap then
				SurfaceAppearance.NormalMapContent = Content.fromObject(p6.NormalMap.editable)
			end

			if p6.RoughnessMap then
				SurfaceAppearance.RoughnessMapContent = Content.fromObject(p6.RoughnessMap.editable)
			end

			if getFFlagUGCValidateAllowEmissives() and p6.EmissiveMask then
				SurfaceAppearance.EmissiveMaskContent = Content.fromObject(p6.EmissiveMask.editable)
			end

			SurfaceAppearance.Parent = v20
		end
	elseif p6 then
		v20.TextureContent = Content.fromObject(p6.editable)
	end

	v20.Name = p4.Name
	v20.Size = p4.Size
	v20.CFrame = p4.CFrame

	for _, child in p4:GetChildren() do
		if (child:IsA("Attachment") or child:IsA("FaceControls")) and (not R15plusUtils.checkFlagEnabledForAllowHrd() or not child:IsA("Bone")) then
			child:Clone().Parent = v20
		end
	end

	if R15plusUtils.checkFlagEnabledForAllowHrd() then
		local v24 = R15plusUtils.getAvatarBoneSchema(p4.Name)

		for v25, v26 in (R15plusUtils.getNameWhitelistOfClassInSchema(v24, "Attachment")) do
			if v26 and v20:FindFirstChild(v25) == nil then
				local v27 = p4:FindFirstChild(v25, true)
				local v28 = if v27 == nil then v20.CFrame else v27.WorldCFrame
				local Attachment = Instance.new("Attachment")

				Attachment.Name = v25
				Attachment.Parent = v20
				Attachment.WorldCFrame = v28
			end
		end
	end

	return v20
end

function t1.createModelForGltfExport(p7) -- line: 113
	-- upvalues: copyMeshPart (copy), createCagePart (copy), getFFlagUGCValidationAddGeometryToExports (copy), ValidationEnums (copy)
	local Model = Instance.new("Model")
	local descendants = p7.rootInstance:GetDescendants()

	table.insert(descendants, p7.rootInstance)

	for _, v34 in descendants do
		if v34:IsA("MeshPart") then
			local Name = v34.Name
			local v36 = p7.renderMeshesData[Name]

			if not v36 then
				error("Missing editable data")
			end

			local v37 = p7.meshTextures[Name]
			local v38 = copyMeshPart(v34, v36, v37)

			v38.Parent = Model

			local v39 = p7.outerCagesData[Name]

			if v39 then
				createCagePart(v38, v36, v39, "OuterCage").Parent = Model
			end

			local v40 = p7.innerCagesData[Name]

			if v40 then
				createCagePart(v38, v36, v40, "InnerCage").Parent = Model
			end

			if getFFlagUGCValidationAddGeometryToExports() and p7.uploadCategory == ValidationEnums.UploadCategory.FULL_BODY then
				v38.Name = `{ Name }_Geo`
			end
		end
	end

	Model:PivotTo(CFrame.new())

	return Model
end

return t1
