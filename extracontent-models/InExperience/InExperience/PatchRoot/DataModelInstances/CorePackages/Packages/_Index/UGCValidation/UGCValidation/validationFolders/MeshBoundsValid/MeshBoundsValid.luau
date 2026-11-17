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
local valueToString = require(parent.util.valueToString)
local getFFlagUGCValidateMeshMaxScale = require(parent.flags.getFFlagUGCValidateMeshMaxScale)
local getFFlagUGCValidateMeshScaleErrorMessage = require(parent.flags.getFFlagUGCValidateMeshScaleErrorMessage)

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

local function truncate(p: number) -- 12 equivalent calls inferred from this helper
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

	-- [DEDUP] synthesized from 2 duplicated terminal regions
	local function deduplicatedTail()
		local v2, v3, _, v4, v5, v6

		if data.consumerConfig.consumerEnv ~= ValidationEnums.ConsumerEnv.IEC then
			v2 = {
				fullName = handle:GetFullName(),
				fieldName = "MeshId",
				editableMesh = handle2.editable,
				scale = scale,
				context = rootInstance.Name
			}

			v3, _, v4, v5 = getMeshMinMax(v2, { isServer = isServer, shouldYield = false })

			if not v3 then
				object:fetchError(string.format("Failed to compute mesh min/max for %s", handle:GetFullName()))
			end

			if v4 and v5 then
				v6 = (v4 + v5) / 2

				if getFIntUGCValidateMeshCenteringHundredsThreshold() / 100 < v6.Magnitude then
					object:fail(ErrorSourceStrings.Keys.MeshGeometry_NotCentered, {
						meshName = handle:GetFullName(),
						fieldName = "MeshId"
					})
				end
			end
		end
	end

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
	elseif
		v3.Position.X > 10000
		or v3.Position.X < -10000
		or v3.Position.Y > 10000
		or v3.Position.Y < -10000
		or v3.Position.Z > 10000
		or v3.Position.Z < -10000
	then
		object:fail(ErrorSourceStrings.Keys.MeshGeometry_PositionOutOfBounds, {})
	elseif scale.X < defineFastInt / 1000 or scale.Y < defineFastInt / 1000 or scale.Z < defineFastInt / 1000 then
		local v4 = math.min(scale.X, scale.Y, scale.Z)

		if not getFFlagUGCValidateMeshScaleErrorMessage() or v4 ~= v4 then
			object:fail(ErrorSourceStrings.Keys.MeshGeometry_ScaleTooSmall, {})
			return
		end

		if v4 <= 0 then
			object:fail(ErrorSourceStrings.Keys.MeshGeometry_ScaleNotPositive, {
				meshName = handle:GetFullName()
			})
			return
		end

		local v5 = defineFastInt / 10
		local v6 = math.clamp(math.round(v4 * 10000) / 100, 0.01, v5 - 0.01)
		object:fail(ErrorSourceStrings.Keys.MeshGeometry_ScaleBelowMinimum, {
			meshName = handle:GetFullName(),
			scalePercent = valueToString(v6),
			minScalePercent = valueToString(v5)
		})
	else
		local editableMeshVerts, v4, v5, _, _, _, _, _, _

		if getFFlagUGCValidateMeshMaxScale() then
			local x = scale.X

			if not (defineFastInt2 / 1000 < x) then
				local y = scale.Y

				if not (defineFastInt2 / 1000 < y) then
					local z = scale.Z

					if not (defineFastInt2 / 1000 < z) then
						editableMeshVerts = UGCValidationService:GetEditableMeshVerts(handle2.editable)

						for k, editableMeshVert in pairs(editableMeshVerts) do
							v4 = handle.CFrame:PointToWorldSpace(editableMeshVert * scale)

							if not pointInBounds(v4, v3, size) then
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

						v5 = (attachment.CFrame.Rotation * handle.Size):Abs()

						if not (v5.X <= size.X and v5.Y <= size.Y and v5.Z <= size.Z) then
							object:fail(ErrorSourceStrings.Keys.MeshGeometry_ExceedsBounds, {
								meshName = handle:GetFullName(),
								assetTypeName = assetType.Name,
								maxSizeX = string.format("%.2f", truncate(size.X)), -- inferred equivalent call
								maxSizeY = string.format("%.2f", truncate(size.Y)), -- inferred equivalent call
								maxSizeZ = string.format("%.2f", truncate(size.Z)) -- inferred equivalent call
							})

							return
						end

						return deduplicatedTail()
					end
				end
			end

			local v6 = math.max(scale.X, scale.Y, scale.Z)

			if not (getFFlagUGCValidateMeshScaleErrorMessage() and v6 < 1e999) then
				object:fail(ErrorSourceStrings.Keys.MeshGeometry_ScaleTooLarge, {
					meshName = handle.Name
				})

				return
			end

			local v7 = defineFastInt2 / 1000
			local v8 = math.max(math.round(v6 * 100) / 100, v7 + 0.01)
			object:fail(ErrorSourceStrings.Keys.MeshGeometry_ScaleAboveMaximum, {
				meshName = handle:GetFullName(),
				scaleMultiple = valueToString(v8),
				maxScaleMultiple = valueToString(v7)
			})
		else
			editableMeshVerts = UGCValidationService:GetEditableMeshVerts(handle2.editable)

			for k, editableMeshVert in pairs(editableMeshVerts) do
				v4 = handle.CFrame:PointToWorldSpace(editableMeshVert * scale)

				if not pointInBounds(v4, v3, size) then
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

			v5 = (attachment.CFrame.Rotation * handle.Size):Abs()

			if not (v5.X <= size.X and v5.Y <= size.Y and v5.Z <= size.Z) then
				object:fail(ErrorSourceStrings.Keys.MeshGeometry_ExceedsBounds, {
					meshName = handle:GetFullName(),
					assetTypeName = assetType.Name,
					maxSizeX = string.format("%.2f", truncate(size.X)), -- inferred equivalent call
					maxSizeY = string.format("%.2f", truncate(size.Y)), -- inferred equivalent call
					maxSizeZ = string.format("%.2f", truncate(size.Z)) -- inferred equivalent call
				})

				return
			end

			return deduplicatedTail()
		end
	end
end

return MeshBoundsValid
