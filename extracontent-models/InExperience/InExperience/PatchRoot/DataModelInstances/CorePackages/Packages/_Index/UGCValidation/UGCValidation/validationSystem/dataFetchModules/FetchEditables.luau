local ParentParent = script.Parent.Parent.Parent
local createEditableInstancesForContext = require(ParentParent.util.createEditableInstancesForContext)
local getMeshSize = require(ParentParent.util.getMeshSize)
local SharedDataMember = require(ParentParent.validationSystem.ValidationEnums).SharedDataMember

require(ParentParent.util.Types)

local getFFlagUGCValidationAddPBRToSharedData = require(ParentParent.flags.getFFlagUGCValidationAddPBRToSharedData)
local getFFlagUGCValidateAllowEmissives = require(ParentParent.flags.getFFlagUGCValidateAllowEmissives)
local t2 = {
	cleanup = function(t1: {[any]: any}) -- line: 20
		-- upvalues: getFFlagUGCValidationAddPBRToSharedData (copy)
		for v15, v16 in t1 do
			if v16.createdInValidation then
				v16.editable:Destroy()
			end

			if getFFlagUGCValidationAddPBRToSharedData() and v16.isPBR ~= nil then
				for _, v18 in v16 do
					if typeof(v18) == "table" and v18.createdInValidation then
						v18.editable:Destroy()
					end
				end
			end

			t1[v15] = nil
		end
	end
}

local function getMeshData(p1, b1: boolean, t3: {[any]: any}) -- line: 45
	-- upvalues: createEditableInstancesForContext (copy), getMeshSize (copy)
	local v22 = p1:IsA("MeshPart") and p1.MeshContent or Content.fromUri(p1.MeshId)
	local v23, v24 = createEditableInstancesForContext.getEditableInstanceInfo(v22, t3, "EditableMesh", b1)

	if not v23 then
		return false
	end

	local v25 = nil
	local vector3 = nil

	if p1:IsA("MeshPart") then
		if p1.MeshContent.SourceType == Enum.ContentSourceType.Object then
			v25 = getMeshSize({
				editableMesh = v24.instance
			})
			vector3 = Vector3.new(1, 1, 1)
		else
			v25 = p1.MeshSize
			vector3 = p1.Size / p1.MeshSize
		end
	elseif p1:IsA("SpecialMesh") then
		v25 = getMeshSize({
			editableMesh = v24.instance
		})
		vector3 = p1.Scale
	end

	return true, {
		editable = v24.instance,
		createdInValidation = v24.created,
		originalSize = v25,
		scale = vector3
	}
end
local function getTextureData_deprecated(p2, b2: boolean, t4: {[any]: any}) -- line: 85
	-- upvalues: createEditableInstancesForContext (copy)
	local v30 = if not p2:IsA("MeshPart") then Content.fromUri(p2.TextureId) else p2.TextureContent
	local v31, v32 = createEditableInstancesForContext.getEditableInstanceInfo(v30, t4, "EditableImage", b2)

	if v31 then
		return true, {
			editable = v32.instance,
			createdInValidation = v32.created
		}
	end

	return false
end
local function getTextureData(p3, b3: boolean, t5: {[any]: any}) -- line: 113
	-- upvalues: getFFlagUGCValidateAllowEmissives (copy), createEditableInstancesForContext (copy), t2 (copy)
	local SurfaceAppearance = p3:FindFirstChildWhichIsA("SurfaceAppearance")
	local t6

	if SurfaceAppearance ~= nil then
		t6 = {
			isPBR = true,
			ColorMap = SurfaceAppearance.ColorMapContent,
			MetalnessMap = SurfaceAppearance.MetalnessMapContent,
			NormalMap = SurfaceAppearance.NormalMapContent,
			RoughnessMap = SurfaceAppearance.RoughnessMapContent
		}

		if getFFlagUGCValidateAllowEmissives() then
			t6.EmissiveMask = SurfaceAppearance.EmissiveMaskContent
		end
	else
		local v38 = if not p3:IsA("MeshPart") then Content.fromUri(p3.TextureId) else p3.TextureContent

		t6 = {
			isPBR = false,
			Texture = v38
		}
	end

	local t7 = {
		isPBR = t6.isPBR
	}

	for v40, v41 in t6 do
		if v40 == "isPBR" or v41.SourceType == Enum.ContentSourceType.None then
			continue
		end

		local v42, v43 = createEditableInstancesForContext.getEditableInstanceInfo(v41, t5, "EditableImage", b3)

		if not v42 then
			t2.cleanup(t7)

			return false
		end

		t7[v40] = {
			editable = v43.instance,
			createdInValidation = v43.created
		}
	end

	return true, t7
end
local function getCageData(p4, b4: boolean, b5: boolean, t8: {[any]: any}) -- line: 172
	-- upvalues: createEditableInstancesForContext (copy), getMeshSize (copy)
	local ReferenceMeshContent, ReferenceOrigin

	if not b4 and p4.ClassName == "WrapLayer" then
		ReferenceMeshContent = p4.ReferenceMeshContent
		ReferenceOrigin = p4.ReferenceOrigin
	else
		ReferenceMeshContent = p4.CageMeshContent
		ReferenceOrigin = p4.CageOrigin
	end

	local v50, v51 = createEditableInstancesForContext.getEditableInstanceInfo(ReferenceMeshContent, t8, "EditableMesh", b5)

	if v50 then
		return true, {
			editable = v51.instance,
			createdInValidation = v51.created,
			originalSize = getMeshSize({
				editableMesh = v51.instance
			}),
			origin = ReferenceOrigin
		}
	end

	return false
end
local function getDataInstance_deprecated(p5, s1: string) -- line: 206
	-- upvalues: SharedDataMember (copy)
	if p5:IsA("MeshPart") or p5:IsA("Part") and p5:FindFirstChildOfClass("SpecialMesh") then
		local v54 = p5:IsA("MeshPart") and p5 or p5:FindFirstChildOfClass("SpecialMesh")

		if s1 == SharedDataMember.meshTextures and (v54.ClassName == "MeshPart" and v54.TextureContent.SourceType == Enum.ContentSourceType.None or v54.ClassName == "SpecialMesh" and v54.TextureId == "") then
			return false
		end

		if s1 == SharedDataMember.renderMeshesData or s1 == SharedDataMember.meshTextures then
			return true, v54
		end

		local BaseWrap = p5:FindFirstChildWhichIsA("BaseWrap")

		if s1 == SharedDataMember.outerCagesData then
			return true, BaseWrap
		end

		if s1 == SharedDataMember.innerCagesData and BaseWrap and BaseWrap.ClassName == "WrapLayer" then
			return true, BaseWrap
		end
	end

	return false
end
local function getDataInstance(p6, s2: string) -- line: 241
	-- upvalues: SharedDataMember (copy)
	local v58 = p6:IsA("MeshPart") and p6 or p6:FindFirstChildOfClass("SpecialMesh")

	if v58 then
		local BaseWrap = p6:FindFirstChildWhichIsA("BaseWrap")

		if s2 == SharedDataMember.renderMeshesData then
			return true, v58
		end

		if s2 == SharedDataMember.meshTextures then
			local v60 = v58:FindFirstChildWhichIsA("SurfaceAppearance") ~= nil
			local v61 = v58.ClassName == "SpecialMesh" and v58.TextureId ~= ""

			return v58.ClassName == "MeshPart" and v58.TextureContent.SourceType ~= Enum.ContentSourceType.None or (v60 or v61), v58
		end

		if s2 == SharedDataMember.outerCagesData and BaseWrap then
			return BaseWrap.CageMeshContent.SourceType ~= Enum.ContentSourceType.None, BaseWrap
		end

		if s2 == SharedDataMember.innerCagesData and BaseWrap and BaseWrap.ClassName == "WrapLayer" then
			return BaseWrap.ReferenceMeshContent.SourceType ~= Enum.ContentSourceType.None, BaseWrap
		end
	end

	return false
end

function t2.getDatas(p7, s3: string, b6: boolean, t9: {[any]: any}, t10: {[any]: any}) -- line: 271
	-- upvalues: getFFlagUGCValidationAddPBRToSharedData (copy), getDataInstance (copy), getDataInstance_deprecated (copy), SharedDataMember (copy), getMeshData (copy), getCageData (copy), getTextureData (copy), getTextureData_deprecated (copy), t2 (copy)
	local t11 = {}
	local descendants = p7:GetDescendants()

	table.insert(descendants, p7)

	for _, v70 in descendants do
		local v71, v72

		if getFFlagUGCValidationAddPBRToSharedData() then
			v71, v72 = getDataInstance(v70, s3)
		else
			v71, v72 = getDataInstance_deprecated(v70, s3)
		end

		if not v71 then
			continue
		end

		local v73 = nil
		local v74 = nil

		if s3 == SharedDataMember.renderMeshesData then
			v73, v74 = getMeshData(v72, b6, t9)
		elseif s3 == SharedDataMember.innerCagesData or s3 == SharedDataMember.outerCagesData then
			local v75 = s3 == SharedDataMember.outerCagesData

			v73, v74 = getCageData(v72, v75, b6, t9)
		elseif s3 == SharedDataMember.meshTextures then
			if getFFlagUGCValidationAddPBRToSharedData() then
				v73, v74 = getTextureData(v72, b6, t10)
			else
				v73, v74 = getTextureData_deprecated(v72, b6, t10)
			end
		end

		if not v73 or v74 == nil then
			t2.cleanup(t11)

			return
		end

		t11[v70.Name] = v74
	end

	return t11
end

return t2
