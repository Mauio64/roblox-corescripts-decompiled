local parent = script.Parent.Parent.Parent
local createEditableInstancesForContext = require(parent.util.createEditableInstancesForContext)
local getMeshSize = require(parent.util.getMeshSize)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local SharedDataMember = ValidationEnums.SharedDataMember
require(parent.util.Types)

local getFFlagUGCValidateEmissiveAreaChecksFixedAlgo = require(parent.flags.getFFlagUGCValidateEmissiveAreaChecksFixedAlgo)

local FetchEditables = {}

function FetchEditables.cleanup(items)
	for k, item in items do
		if item.createdInValidation then
			item.editable:Destroy()
		end

		if item.isPBR ~= nil then
			for _, v in item do
				if typeof(v) == "table" and v.createdInValidation then
					v.editable:Destroy()
				end
			end
		end

		items[k] = nil
	end
end

local function getMeshData(instance, flag: boolean, p)
	local meshContent = instance:IsA("MeshPart") and instance.MeshContent or Content.fromUri(instance.MeshId)
	local editableInstanceInfo, v = createEditableInstancesForContext.getEditableInstanceInfo(
		meshContent,
		p,
		"EditableMesh",
		flag
	)

	if not editableInstanceInfo then
		return false
	end

	local originalSize = nil
	local scale = nil

	if instance:IsA("MeshPart") then
		if instance.MeshContent.SourceType == Enum.ContentSourceType.Object then
			originalSize = getMeshSize({ editableMesh = v.instance })
			scale = Vector3.new(1, 1, 1)
		else
			originalSize = instance.MeshSize
			scale = instance.Size / instance.MeshSize
		end
	elseif instance:IsA("SpecialMesh") then
		originalSize = getMeshSize({ editableMesh = v.instance })
		scale = instance.Scale
	end

	return true, {
		editable = v.instance,
		createdInValidation = v.created,
		originalSize = originalSize,
		scale = scale
	}
end

local function getTextureData(part, flag: boolean, p)
	local surfaceAppearance = part:FindFirstChildWhichIsA("SurfaceAppearance")
	local v

	if surfaceAppearance == nil then
		local texture

		if part:IsA("MeshPart") then
			texture = part.TextureContent
		else
			texture = Content.fromUri(part.TextureId)
		end

		v = { isPBR = false, Texture = texture }
	else
		v = {
			isPBR = true,
			ColorMap = surfaceAppearance.ColorMapContent,
			MetalnessMap = surfaceAppearance.MetalnessMapContent,
			NormalMap = surfaceAppearance.NormalMapContent,
			RoughnessMap = surfaceAppearance.RoughnessMapContent
		}

		v.EmissiveMask = surfaceAppearance.EmissiveMaskContent
	end

	local result = { isPBR = v.isPBR }

	if getFFlagUGCValidateEmissiveAreaChecksFixedAlgo() and surfaceAppearance ~= nil then
		result.EmissiveTint = surfaceAppearance.EmissiveTint
		result.EmissiveStrength = surfaceAppearance.EmissiveStrength
	end

	for k, v2 in v do
		if getFFlagUGCValidateEmissiveAreaChecksFixedAlgo() then
			if
				k == "isPBR"
				or k == "EmissiveTint"
				or k == "EmissiveStrength"
				or v2.SourceType == Enum.ContentSourceType.None
			then
				continue
			end
		elseif k == "isPBR" or v2.SourceType == Enum.ContentSourceType.None then
			continue
		end

		local editableInstanceInfo, v3 = createEditableInstancesForContext.getEditableInstanceInfo(
			v2,
			p,
			"EditableImage",
			flag
		)

		if editableInstanceInfo then
			result[k] = { editable = v3.instance, createdInValidation = v3.created }
		else
			FetchEditables.cleanup(result)
			return false
		end
	end

	return true, result
end

local function getCageData(instance, flag: boolean, flag2: boolean, p)
	local v, origin

	if flag or instance.ClassName ~= "WrapLayer" then
		v = instance.CageMeshContent
		origin = instance.CageOrigin
	else
		v = instance.ReferenceMeshContent
		origin = instance.ReferenceOrigin
	end

	local editableInstanceInfo, v2 = createEditableInstancesForContext.getEditableInstanceInfo(
		v,
		p,
		"EditableMesh",
		flag2
	)

	if editableInstanceInfo then
		return true, {
			editable = v2.instance,
			createdInValidation = v2.created,
			originalSize = getMeshSize({ editableMesh = v2.instance }),
			origin = origin
		}
	end

	return false
end

local function getDataInstance(part, p: string)
	local v = part:IsA("MeshPart") and part or part:FindFirstChildOfClass("SpecialMesh")

	if not v then
		return false
	end

	local baseWrap = part:FindFirstChildWhichIsA("BaseWrap")

	if p == SharedDataMember.renderMeshesData then
		return true, v
	end

	if p == SharedDataMember.meshTextures then
		local v2 = v:FindFirstChildWhichIsA("SurfaceAppearance") ~= nil
		local v3 = v.ClassName == "SpecialMesh" and v.TextureId ~= ""
		return v.ClassName == "MeshPart" and v.TextureContent.SourceType ~= Enum.ContentSourceType.None or v2 or v3, v
	end

	if p == SharedDataMember.outerCagesData and baseWrap then
		return baseWrap.CageMeshContent.SourceType ~= Enum.ContentSourceType.None, baseWrap
	end

	if p == SharedDataMember.innerCagesData and baseWrap and baseWrap.ClassName == "WrapLayer" then
		return baseWrap.ReferenceMeshContent.SourceType ~= Enum.ContentSourceType.None, baseWrap
	end

	return false
end

function FetchEditables.getDatas(folder, p: string, flag: boolean, p2, p3)
	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)
	local result = {}

	for _, descendant in descendants do
		local dataInstance, v = getDataInstance(descendant, p)

		if not dataInstance then
			continue
		end

		local v2 = nil
		local v3 = nil

		if p == SharedDataMember.renderMeshesData then
			v2, v3 = getMeshData(v, flag, p2)
		elseif p == SharedDataMember.innerCagesData or p == SharedDataMember.outerCagesData then
			v2, v3 = getCageData(v, p == SharedDataMember.outerCagesData, flag, p2)
		elseif p == SharedDataMember.meshTextures then
			v2, v3 = getTextureData(v, flag, p3)
		end

		if v2 and v3 ~= nil then
			result[descendant.Name] = v3
		else
			FetchEditables.cleanup(result)
			return
		end
	end

	return result
end

return FetchEditables
