local parent = script.Parent.Parent
local CreateEditableInstancesForContext = {}

local AssetService = game:GetService("AssetService")
local UGCValidationService = game:GetService("UGCValidationService")

require(parent.util.Types)
local destroyEditableInstances = require(parent.util.destroyEditableInstances)

local function addEditableInstance(p, p2, k, p3, contentType) -- 1 equivalent call inferred from this helper
	local v = p.editableMeshes

	if contentType == "EditableImage" then
		v = p.editableImages
	end

	if not v[p2] then
		v[p2] = {}
	end

	v[p2][k] = p3
end

local function createEditableInstanceFromId(p, p2, p3)
	local success, result = pcall(function()
		if p3 == "EditableMesh" then
			return AssetService:CreateEditableMeshAsync(p)
		end

		return UGCValidationService:CreateEditableImageOriginalSizeAsync(p.Uri)
	end)

	if not success then
		return success, result
	end

	p2[p.Uri] = result
	return true, { created = true, instance = result }
end

function CreateEditableInstancesForContext.getEditableInstanceInfo(p, p2, p3, p4)
	local instance

	if p4 then
		instance = p.Object
	end

	if not instance then
		local uri = p.Uri

		if uri and uri ~= "" then
			instance = p2[uri]

			if not instance then
				return createEditableInstanceFromId(p, p2, p3)
			end
		end
	end

	return true, { instance = instance, created = false }
end

local function addContent(p, p2, content, contentType) -- 12 equivalent calls inferred from this helper
	p[p2] = { content = content, contentType = contentType }
end

local function getTextureContentMap(instance, p)
	if instance:IsA("MeshPart") then
		addContent(p, "TextureID", instance.TextureContent, "EditableImage") -- inferred equivalent call
	elseif instance:IsA("SpecialMesh") then
		addContent(p, "TextureId", Content.fromUri(instance.TextureId), "EditableImage") -- inferred equivalent call
	elseif instance:IsA("SurfaceAppearance") or instance:IsA("Decal") then
		addContent(p, "ColorMap", instance.ColorMapContent, "EditableImage") -- inferred equivalent call

		addContent(p, "MetalnessMap", instance.MetalnessMapContent, "EditableImage") -- inferred equivalent call

		addContent(p, "NormalMap", instance.NormalMapContent, "EditableImage") -- inferred equivalent call

		addContent(p, "RoughnessMap", instance.RoughnessMapContent, "EditableImage") -- inferred equivalent call
	end
end

local function getCageMeshContent(instance) -- 2 equivalent calls inferred from this helper
	return instance.CageMeshContent
end

local function getMeshContentMap(instance, p)
	if instance:IsA("MeshPart") then
		addContent(p, "MeshId", instance.MeshContent, "EditableMesh") -- inferred equivalent call
	elseif instance:IsA("WrapTarget") then
		addContent(p, "CageMeshId", getCageMeshContent(instance), "EditableMesh") -- inferred equivalent call
	elseif instance:IsA("WrapLayer") then
		addContent(p, "CageMeshId", getCageMeshContent(instance), "EditableMesh") -- inferred equivalent call
		addContent(p, "ReferenceMeshId", instance.ReferenceMeshContent, "EditableMesh") -- inferred equivalent call
	elseif instance:IsA("SpecialMesh") then
		addContent(p, "MeshId", Content.fromUri(instance.MeshId), "EditableMesh") -- inferred equivalent call
	elseif instance:IsA("WrapTextureTransfer") then
		addContent(p, "ReferenceCageMeshContent", instance.ReferenceCageMeshContent, "EditableMesh") -- inferred equivalent call
	end
end

function CreateEditableInstancesForContext.getOrCreateEditableInstances(p, p2, p3, p4)
	local v = {}
	getMeshContentMap(p, v)
	getTextureContentMap(p, v)

	for k, v2 in v do
		local contentType = v2.contentType
		local editableInstanceInfo, v3 = CreateEditableInstancesForContext.getEditableInstanceInfo(
			v2.content,
			p2,
			contentType,
			p4
		)

		if not editableInstanceInfo then
			return editableInstanceInfo, v3
		end

		addEditableInstance(p3, p, k, v3, contentType) -- inferred equivalent call
	end

	return true
end

function CreateEditableInstancesForContext.processAll(items, flag: boolean?)
	local v = {}
	local v2 = { editableMeshes = {}, editableImages = {} }

	for _, folder in items do
		local descendants = folder:GetDescendants()
		table.insert(descendants, folder)

		for _, descendant in pairs(descendants) do
			local editableInstances, v3 = CreateEditableInstancesForContext.getOrCreateEditableInstances(
				descendant,
				v,
				v2,
				flag
			)

			if not editableInstances then
				destroyEditableInstances(v2.editableMeshes, v2.editableImages)

				return false, { v3 }
			end
		end
	end

	return true, v2
end

return CreateEditableInstancesForContext
