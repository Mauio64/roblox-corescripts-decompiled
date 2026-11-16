local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getAccessoryScale = require(parent.util.getAccessoryScale)
local getAttachment = require(parent.util.getAttachment)
local getMeshMinMax = require(parent.util.getMeshMinMax)
local isMeshPartAccessory = require(parent.util.isMeshPartAccessory)
local getFFlagUGCValidateMeshMaxScale = require(parent.flags.getFFlagUGCValidateMeshMaxScale)

local getFIntUGCValidateMeshCenteringHundredsThreshold = require(parent.flags.getFIntUGCValidateMeshCenteringHundredsThreshold)

local defineFastFlag = game:DefineFastFlag("LegacyAccessoryCheckAvatarPartScaleType", false)

local defineFastFlag2 = game:DefineFastFlag("MeshpartAccessoryCheckAvatarPartScaleType", false)

local defineFastInt = game:DefineFastInt("UGCValidationScaleMinimumThousandths", 10)
local defineFastInt2 = game:DefineFastInt("FIntUGCValidationScaleMaximumThousandths", 10000)

local MeshBoundsValid = {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {}
}

local function pointInBounds(vector3: Vector3, cframe: CFrame, size: Vector3): boolean
	local pointToObjectSpace = cframe:PointToObjectSpace(vector3)
	return pointToObjectSpace.X >= -size.X / 2
		and pointToObjectSpace.X <= size.X / 2
		and pointToObjectSpace.Y >= -size.Y / 2
		and pointToObjectSpace.Y <= size.Y / 2
		and pointToObjectSpace.Z >= -size.Z / 2
		and pointToObjectSpace.Z <= size.Z / 2
end

local function truncate(p: number) -- 6 equivalent calls inferred from this helper
	return math.floor(p * 100) / 100
end

function MeshBoundsValid.run(object, data)
	local rootInstance = data.rootInstance
	local assetType = data.uploadEnum.assetType
	local isServer = data.consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend

	local v = Constants.ASSET_TYPE_INFO[assetType]

	if not v then
		return
	end

	local handle = rootInstance:FindFirstChild("Handle")

	if not handle then
		return
	end

	local handle2 = data.renderMeshesData.Handle

	if not handle2 then
		return
	end

	local attachment = getAttachment(handle, v.attachmentNames)

	if not attachment then
		return
	end

	local bound = v.bounds[attachment.Name]

	if not bound then
		return
	end

	local scale = handle2.scale
	local size = bound.size
	local v2 = bound.offset or Vector3.new(0, 0, 0)

	if data.uploadCategory == ValidationEnums.UploadCategory.RIGID_ACCESSORY then
		local v3

		if isMeshPartAccessory(rootInstance) then
			v3 = defineFastFlag2
		else
			v3 = defineFastFlag
		end

		if v3 and handle:FindFirstChild("AvatarPartScaleType") then
			local accessoryScale = getAccessoryScale(handle, attachment)
			size /= accessoryScale

			if bound.offset then
				v2 = bound.offset / accessoryScale
			else
				v2 = Vector3.new(0, 0, 0)
			end
		end
	end

	local v3 = handle.CFrame * attachment.CFrame * CFrame.new(v2)

	if
		handle.Position.X > 10000
		or handle.Position.X < -10000
		or handle.Position.Y > 10000
		or handle.Position.Y < -10000
		or handle.Position.Z > 10000
		or handle.Position.Z < -10000
	then
		object:fail(ErrorSourceStrings.Keys.MeshGeometry_PositionOutOfBounds, {})
		return
	end

	if
		v3.Position.X > 10000
		or v3.Position.X < -10000
		or v3.Position.Y > 10000
		or v3.Position.Y < -10000
		or v3.Position.Z > 10000
		or v3.Position.Z < -10000
	then
		object:fail(ErrorSourceStrings.Keys.MeshGeometry_PositionOutOfBounds, {})
		return
	end

	if scale.X < defineFastInt / 1000 or scale.Y < defineFastInt / 1000 or scale.Z < defineFastInt / 1000 then
		object:fail(ErrorSourceStrings.Keys.MeshGeometry_ScaleTooSmall, {})
		return
	end

	local editableMeshVerts, _, _, _, _, _, _

	-- [DEDUP] synthesized from 2 duplicated terminal regions
	local function deduplicatedTail()
		local v4, v5, v6, v7, v8, v9

		for _, v10 in pairs(editableMeshVerts) do
			if not pointInBounds(handle.CFrame:PointToWorldSpace(v10 * scale), v3, size) then
				object:fail(ErrorSourceStrings.Keys.MeshGeometry_ExceedsBounds, {
					meshName = rootInstance.Name,
					assetTypeName = assetType.Name,
					maxSizeX = string.format("%.2f", truncate(size.X)), -- inferred equivalent call
					maxSizeY = string.format("%.2f", truncate(size.Y)), -- inferred equivalent call
					maxSizeZ = string.format("%.2f", truncate(size.Z)) -- inferred equivalent call
				})

				return
			end
		end

		v4 = (attachment.CFrame.Rotation * handle.Size):Abs()

		if not (v4.X <= size.X and v4.Y <= size.Y and v4.Z <= size.Z) then
			object:fail(ErrorSourceStrings.Keys.MeshGeometry_ExceedsBounds, {
				meshName = handle:GetFullName(),
				assetTypeName = assetType.Name,
				maxSizeX = string.format("%.2f", truncate(size.X)), -- inferred equivalent call
				maxSizeY = string.format("%.2f", truncate(size.Y)), -- inferred equivalent call
				maxSizeZ = string.format("%.2f", truncate(size.Z)) -- inferred equivalent call
			})
		elseif data.consumerConfig.consumerEnv ~= ValidationEnums.ConsumerEnv.IEC then
			v5, v6, v7, v8 = getMeshMinMax({
				fullName = handle:GetFullName(),
				fieldName = "MeshId",
				editableMesh = handle2.editable,
				scale = scale,
				context = rootInstance.Name
			}, { isServer = isServer, shouldYield = false })

			if not v5 then
				object:fetchError(string.format("Failed to compute mesh min/max for %s", handle:GetFullName()))
			end

			if v7 and v8 then
				v9 = (v7 + v8) / 2

				if getFIntUGCValidateMeshCenteringHundredsThreshold() / 100 < v9.Magnitude then
					object:fail(ErrorSourceStrings.Keys.MeshGeometry_NotCentered, {
						meshName = handle:GetFullName(),
						fieldName = "MeshId"
					})
				end
			end
		end
	end

	if getFFlagUGCValidateMeshMaxScale() then
		local x = scale.X

		if not (defineFastInt2 / 1000 < x) then
			local y = scale.Y

			if not (defineFastInt2 / 1000 < y) then
				local z = scale.Z

				if not (defineFastInt2 / 1000 < z) then
					editableMeshVerts = UGCValidationService:GetEditableMeshVerts(handle2.editable)
					return deduplicatedTail()
				end
			end
		end

		object:fail(ErrorSourceStrings.Keys.MeshGeometry_ScaleTooLarge, { meshName = handle.Name })
	else
		editableMeshVerts = UGCValidationService:GetEditableMeshVerts(handle2.editable)
		return deduplicatedTail()
	end
end

return MeshBoundsValid
