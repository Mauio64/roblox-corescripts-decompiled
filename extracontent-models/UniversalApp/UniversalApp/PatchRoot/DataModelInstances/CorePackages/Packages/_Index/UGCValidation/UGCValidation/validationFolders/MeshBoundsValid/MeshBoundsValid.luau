local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getAccessoryScale = require(ParentParent.util.getAccessoryScale)
local getAttachment = require(ParentParent.util.getAttachment)
local getMeshMinMax = require(ParentParent.util.getMeshMinMax)
local isMeshPartAccessory = require(ParentParent.util.isMeshPartAccessory)
local getFFlagUGCValidateMeshMaxScale = require(ParentParent.flags.getFFlagUGCValidateMeshMaxScale)
local getFIntUGCValidateMeshCenteringHundredsThreshold = require(ParentParent.flags.getFIntUGCValidateMeshCenteringHundredsThreshold)
local getFFlagUGCValidateMigrateMeshGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateMeshGeometry)
local v13 = game:DefineFastFlag("LegacyAccessoryCheckAvatarPartScaleType", false)
local v14 = game:DefineFastFlag("MeshpartAccessoryCheckAvatarPartScaleType", false)
local v15 = game:DefineFastInt("UGCValidationScaleMinimumThousandths", 10)
local v16 = game:DefineFastInt("FIntUGCValidationScaleMaximumThousandths", 10000)
local v17 = game:DefineFastFlag("RenderBoundsCheckAttachmentOrientation", false)
local t1 = {
	fflag = getFFlagUGCValidateMigrateMeshGeometry,
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {}
}

local function pointInBounds(vector3: Vector3, cFrame: CFrame, vector3_2: Vector3) -- line: 40
	local v24 = cFrame:PointToObjectSpace(vector3)

	return v24.X >= -vector3_2.X / 2 and (v24.X <= vector3_2.X / 2 and (v24.Y >= -vector3_2.Y / 2 and (v24.Y <= vector3_2.Y / 2 and (v24.Z >= -vector3_2.Z / 2 and v24.Z <= vector3_2.Z / 2))))
end
local function truncate(n1: number) -- line: 50
	return math.floor(n1 * 100) / 100
end

function t1.run(p1, p2) -- line: 54
	-- upvalues: ValidationEnums (copy), Constants (copy), getAttachment (copy), isMeshPartAccessory (copy), v14 (copy), v13 (copy), getAccessoryScale (copy), ErrorSourceStrings (copy), v15 (copy), getFFlagUGCValidateMeshMaxScale (copy), v16 (copy), UGCValidationService (copy), pointInBounds (copy), v17 (copy), getMeshMinMax (copy), getFIntUGCValidateMeshCenteringHundredsThreshold (copy)
	local rootInstance = p2.rootInstance
	local assetType = p2.uploadEnum.assetType
	local v30 = p2.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend
	local v31 = Constants.ASSET_TYPE_INFO[assetType]

	if not v31 then
		return
	end

	local Handle = rootInstance:FindFirstChild("Handle")

	if not Handle then
		return
	end

	local Handle2 = p2.renderMeshesData.Handle

	if not Handle2 then
		return
	end

	local v34 = getAttachment(Handle, v31.attachmentNames)

	if not v34 then
		return
	end

	local v35 = v31.bounds[v34.Name]

	if not v35 then
		return
	end

	local scale = Handle2.scale
	local size = v35.size
	local v38 = v35.offset or Vector3.new(0, 0, 0)

	if p2.uploadCategory == ValidationEnums.UploadCategory.RIGID_ACCESSORY and (if not isMeshPartAccessory(rootInstance) then v13 else v14) and Handle:FindFirstChild("AvatarPartScaleType") then
		local v39 = getAccessoryScale(Handle, v34)

		size /= v39
		v38 = if not v35.offset then Vector3.new(0, 0, 0) else v35.offset / v39
	end

	local v40 = Handle.CFrame * v34.CFrame * CFrame.new(v38)

	if Handle.Position.X > 10000 or Handle.Position.X < -10000 or Handle.Position.Y > 10000 or Handle.Position.Y < -10000 or Handle.Position.Z > 10000 or Handle.Position.Z < -10000 then
		p1:fail(ErrorSourceStrings.Keys.MeshGeometry_PositionOutOfBounds, {})

		return
	end

	if v40.Position.X > 10000 or v40.Position.X < -10000 or v40.Position.Y > 10000 or v40.Position.Y < -10000 or v40.Position.Z > 10000 or v40.Position.Z < -10000 then
		p1:fail(ErrorSourceStrings.Keys.MeshGeometry_PositionOutOfBounds, {})

		return
	end

	if scale.X < v15 / 1000 or scale.Y < v15 / 1000 or scale.Z < v15 / 1000 then
		p1:fail(ErrorSourceStrings.Keys.MeshGeometry_ScaleTooSmall, {})

		return
	end

	if getFFlagUGCValidateMeshMaxScale() and (scale.X > v16 / 1000 or scale.Y > v16 / 1000 or scale.Z > v16 / 1000) then
		p1:fail(ErrorSourceStrings.Keys.MeshGeometry_ScaleTooLarge, {
			meshName = Handle.Name
		})

		return
	end

	local EditableMeshVerts = UGCValidationService:GetEditableMeshVerts(Handle2.editable)

	for _, v in pairs(EditableMeshVerts) do
		local v44 = Handle.CFrame:PointToWorldSpace(v * scale)

		if not pointInBounds(v44, v40, size) then
			p1:fail(ErrorSourceStrings.Keys.MeshGeometry_ExceedsBounds, {
				meshName = rootInstance.Name,
				assetTypeName = assetType.Name,
				maxSizeX = string.format("%.2f", math.floor(size.X * 100) / 100),
				maxSizeY = string.format("%.2f", math.floor(size.Y * 100) / 100),
				maxSizeZ = string.format("%.2f", math.floor(size.Z * 100) / 100)
			})

			return
		end
	end

	if v17 then
		local v45 = (v34.CFrame.Rotation * Handle.Size):Abs()

		if not (v45.X <= size.X) or not (v45.Y <= size.Y) or not (v45.Z <= size.Z) then
			p1:fail(ErrorSourceStrings.Keys.MeshGeometry_ExceedsBounds, {
				meshName = Handle:GetFullName(),
				assetTypeName = assetType.Name,
				maxSizeX = string.format("%.2f", math.floor(size.X * 100) / 100),
				maxSizeY = string.format("%.2f", math.floor(size.Y * 100) / 100),
				maxSizeZ = string.format("%.2f", math.floor(size.Z * 100) / 100)
			})

			return
		end
	elseif not (Handle.Size.X <= size.X) or not (Handle.Size.Y <= size.Y) or not (Handle.Size.Z <= size.Z) then
		p1:fail(ErrorSourceStrings.Keys.MeshGeometry_ExceedsBounds, {
			meshName = Handle:GetFullName(),
			assetTypeName = assetType.Name,
			maxSizeX = string.format("%.2f", math.floor(size.X * 100) / 100),
			maxSizeY = string.format("%.2f", math.floor(size.Y * 100) / 100),
			maxSizeZ = string.format("%.2f", math.floor(size.Z * 100) / 100)
		})

		return
	end

	if p2.consumerConfig.consumerEnv ~= ValidationEnums.ConsumerEnv.IEC then
		local t2 = {
			fieldName = "MeshId",
			fullName = Handle:GetFullName(),
			editableMesh = Handle2.editable,
			scale = scale,
			context = rootInstance.Name
		}
		local t3 = {
			shouldYield = false,
			isServer = v30
		}
		local v48, _, v50, v51 = getMeshMinMax(t2, t3)

		if not v48 then
			p1:fetchError(string.format("Failed to compute mesh min/max for %s", Handle:GetFullName()))
		end

		if v50 and v51 then
			local v52 = (v50 + v51) / 2

			if getFIntUGCValidateMeshCenteringHundredsThreshold() / 100 < v52.Magnitude then
				p1:fail(ErrorSourceStrings.Keys.MeshGeometry_NotCentered, {
					fieldName = "MeshId",
					meshName = Handle:GetFullName()
				})
			end
		end
	end
end

return t1
