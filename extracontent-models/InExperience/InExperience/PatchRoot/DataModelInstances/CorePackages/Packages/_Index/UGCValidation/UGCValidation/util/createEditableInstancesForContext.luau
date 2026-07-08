local ParentParent = script.Parent.Parent
local t1 = {}
local AssetService = game:GetService("AssetService")
local UGCValidationService = game:GetService("UGCValidationService")

require(ParentParent.util.Types)

local destroyEditableInstances = require(ParentParent.util.destroyEditableInstances)

local function addEditableInstance(p1, p2, p3, p4, p5) -- line: 13
	local editableMeshes = p1.editableMeshes

	if p5 == "EditableImage" then
		editableMeshes = p1.editableImages
	end

	if not editableMeshes[p2] then
		editableMeshes[p2] = {}
	end

	editableMeshes[p2][p3] = p4
end
local function createEditableInstanceFromId(p6, p7, p8) -- line: 26
	-- upvalues: AssetService (copy), UGCValidationService (copy)
	local ok, result = pcall(function() -- line: 27
		-- upvalues: p8 (copy), AssetService (copy), p6 (copy), UGCValidationService (copy)
		if p8 == "EditableMesh" then
			return AssetService:CreateEditableMeshAsync(p6)
		end

		return UGCValidationService:CreateEditableImageOriginalSizeAsync(p6.Uri)
	end)

	if not ok then
		return ok, result
	end

	p7[p6.Uri] = result

	return true, {
		created = true,
		instance = result
	}
end

function t1.getEditableInstanceInfo(p9, p10, p11, p12) -- line: 46
	-- upvalues: createEditableInstanceFromId (copy)
	local Object = nil

	if p12 then
		Object = p9.Object
	end

	if not Object then
		local Uri = p9.Uri

		if Uri and Uri ~= "" then
			Object = p10[Uri]

			if not Object then
				return createEditableInstanceFromId(p9, p10, p11)
			end
		end
	end

	return true, {
		created = false,
		instance = Object
	}
end

local function addContent(p13, p14, p15, p16) -- line: 72
	p13[p14] = {
		content = p15,
		contentType = p16
	}
end
local function getTextureContentMap(p17, p18) -- line: 79
	if p17:IsA("MeshPart") then
		local TextureContent = p17.TextureContent

		p18.TextureID = {
			contentType = "EditableImage",
			content = TextureContent
		}

		return
	end

	if p17:IsA("SpecialMesh") then
		local v36 = Content.fromUri(p17.TextureId)

		p18.TextureId = {
			contentType = "EditableImage",
			content = v36
		}

		return
	end

	if p17:IsA("SurfaceAppearance") or p17:IsA("Decal") then
		local ColorMapContent = p17.ColorMapContent

		p18.ColorMap = {
			contentType = "EditableImage",
			content = ColorMapContent
		}

		local MetalnessMapContent = p17.MetalnessMapContent

		p18.MetalnessMap = {
			contentType = "EditableImage",
			content = MetalnessMapContent
		}

		local NormalMapContent = p17.NormalMapContent

		p18.NormalMap = {
			contentType = "EditableImage",
			content = NormalMapContent
		}

		local RoughnessMapContent = p17.RoughnessMapContent

		p18.RoughnessMap = {
			contentType = "EditableImage",
			content = RoughnessMapContent
		}
	end
end
local function getCageMeshContent(p19) -- line: 118
	return p19.CageMeshContent
end
local function getMeshContentMap(p20, p21) -- line: 122
	if p20:IsA("MeshPart") then
		local MeshContent = p20.MeshContent

		p21.MeshId = {
			contentType = "EditableMesh",
			content = MeshContent
		}

		return
	end

	if p20:IsA("WrapTarget") then
		local CageMeshContent = p20.CageMeshContent

		p21.CageMeshId = {
			contentType = "EditableMesh",
			content = CageMeshContent
		}

		return
	end

	if p20:IsA("WrapLayer") then
		local CageMeshContent = p20.CageMeshContent

		p21.CageMeshId = {
			contentType = "EditableMesh",
			content = CageMeshContent
		}

		local ReferenceMeshContent = p20.ReferenceMeshContent

		p21.ReferenceMeshId = {
			contentType = "EditableMesh",
			content = ReferenceMeshContent
		}

		return
	end

	if p20:IsA("SpecialMesh") then
		local v48 = Content.fromUri(p20.MeshId)

		p21.MeshId = {
			contentType = "EditableMesh",
			content = v48
		}

		return
	end

	if p20:IsA("WrapTextureTransfer") then
		local ReferenceCageMeshContent = p20.ReferenceCageMeshContent

		p21.ReferenceCageMeshContent = {
			contentType = "EditableMesh",
			content = ReferenceCageMeshContent
		}
	end
end

function t1.getOrCreateEditableInstances(p22, p23, p24, p25) -- line: 143
	-- upvalues: getMeshContentMap (copy), getTextureContentMap (copy), t1 (copy)
	local t2 = {}

	getMeshContentMap(p22, t2)
	getTextureContentMap(p22, t2)

	for v55, v56 in t2 do
		local contentType = v56.contentType
		local v58, v59 = t1.getEditableInstanceInfo(v56.content, p23, contentType, p25)

		if not v58 then
			return v58, v59
		end

		local editableMeshes = p24.editableMeshes

		if contentType == "EditableImage" then
			editableMeshes = p24.editableImages
		end

		if not editableMeshes[p22] then
			editableMeshes[p22] = {}
		end

		editableMeshes[p22][v55] = v59
	end

	return true
end
function t1.processAll(t3: {[any]: any}, b1: boolean?) -- line: 171
	-- upvalues: t1 (copy), destroyEditableInstances (copy)
	local t4 = {
		editableMeshes = {},
		editableImages = {}
	}

	for _, v65 in t3 do
		local descendants = v65:GetDescendants()

		table.insert(descendants, v65)

		for _, v in pairs(descendants) do
			local v69, v70 = t1.getOrCreateEditableInstances(v, {}, t4, b1)

			if not v69 then
				destroyEditableInstances(t4.editableMeshes, t4.editableImages)

				return false, { v70 }
			end
		end
	end

	return true, t4
end

return t1
