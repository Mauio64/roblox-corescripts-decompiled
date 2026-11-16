local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
local ConstantsInterface = require(parent.ConstantsInterface)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local createEditableInstancesForContext = require(parent.util.createEditableInstancesForContext)

local getFFlagUGCValidateDecalTextureLimits = require(parent.flags.getFFlagUGCValidateDecalTextureLimits)
local getFFlagUGCValidationAllowFullVaas = require(parent.flags.getFFlagUGCValidationAllowFullVaas)

local defineFastInt = game:DefineFastInt("ValidateMakeupZoneIncludeToleranceHundredthsPercent", 100)

local defineFastInt2 = game:DefineFastInt("ValidateMakeupZoneExcludeHundredthsPercent", 200)

local v = { Publish = true, Backend = true, Internal = true, InExpServer = true }

local v2 = { InExpServer = true, InExpClient = true }

local MakeupDecalValid = {
	categories = { ValidationEnums.UploadCategory.MAKEUP },
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	expectedFailures = {}
}

local function validateTextureSize(object, instance, fullName: string, fieldName: string, p: number, flag: boolean)
	local success, result = pcall(function()
		return UGCValidationService:GetEditableImageSize(instance)
	end)

	if success then
		if p < result.X or p < result.Y then
			object:fail(ErrorSourceStrings.Keys.MakeupDecal_TextureTooBig, {
				sizeX = tostring(result.X),
				sizeY = tostring(result.Y),
				fullName = fullName,
				maxSize = tostring(p),
				fieldName = fieldName
			})
		end
	else
		if flag then
			object:forceError(string.format(
				"Failed to load texture data for '%s'. Make sure the texture exists and try again.",
				fullName
			))
		end

		object:fail(ErrorSourceStrings.Keys.MakeupDecal_FailedToLoadTextureData, {
			fullName = fullName
		})
	end
end

local function validateCoverageOutsideIncludeBounds(object, p, object2, vector2: Vector2, vector2_2: Vector2, item, assetTypeName: string)
	local v3 = (vector2_2.X - vector2.X) * (vector2_2.Y - vector2.Y) * defineFastInt / 10000 * 255

	local pixelsBuffer = object2:ReadPixelsBuffer(Vector2.new(0, 0), object2.Size)

	local v4 = object2.Size.Y - 1
	local count = 0
	local total = 0

	for i = 0, buffer.len(pixelsBuffer) - 1, 4 do
		if count == object2.Size.X then
			v4 -= 1
			count = 0
		end

		local v5 = buffer.readu8(pixelsBuffer, i + 3)

		if v5 > 0 and (count < vector2.X or v4 < vector2.Y or vector2_2.X < count or vector2_2.Y < v4) then
			total += v5
		end

		count += 1
	end

	if v3 < total then
		object:fail(ErrorSourceStrings.Keys.MakeupDecal_UVZoneIncludeViolation, {
			instanceName = p.Name,
			minBound = tostring(item.MinBound),
			maxBound = tostring(item.MaxBound),
			assetTypeName = assetTypeName
		})
	end
end

local function validateCoverageInsideExcludeBounds(object, p, object2, vector2: Vector2, vector2_2: Vector2, item, assetTypeName: string)
	local v3 = (vector2_2.X - vector2.X) * (vector2_2.Y - vector2.Y) * defineFastInt2 / 10000 * 255

	local pixelsBuffer = object2:ReadPixelsBuffer(Vector2.new(0, 0), object2.Size)

	local v4 = object2.Size.Y - 1
	local count = 0
	local total = 0

	for i = 0, buffer.len(pixelsBuffer) - 1, 4 do
		if count == object2.Size.X then
			v4 -= 1
			count = 0
		end

		local v5 = buffer.readu8(pixelsBuffer, i + 3)

		if v5 > 0 and vector2.X < count and vector2.Y < v4 and count < vector2_2.X and v4 < vector2_2.Y then
			total += v5
		end

		count += 1
	end

	if v3 < total then
		object:fail(ErrorSourceStrings.Keys.MakeupDecal_UVZoneExcludeViolation, {
			instanceName = p.Name,
			minBound = tostring(item.MinBound),
			maxBound = tostring(item.MaxBound),
			assetTypeName = assetTypeName
		})
	end
end

local function validateUVZones(object, rootInstance, p, wrapTextureTransfer, assetUVBound, name: string)
	local v3 = wrapTextureTransfer.UVMaxBound - wrapTextureTransfer.UVMinBound

	for _, item in assetUVBound do
		local v4 = (item.MinBound - wrapTextureTransfer.UVMinBound) / v3
		local v5 = (item.MaxBound - wrapTextureTransfer.UVMinBound) / v3

		local v6 = v4 * p.Size
		local v7 = v5 * p.Size

		if item.isIncludeBound then
			validateCoverageOutsideIncludeBounds(object, rootInstance, p, v6, v7, item, name)
		else
			validateCoverageInsideExcludeBounds(object, rootInstance, p, v6, v7, item, name)
		end
	end
end

function MakeupDecalValid.run(object, data)
	local rootInstance = data.rootInstance
	local assetType = data.uploadEnum.assetType
	local consumerConfig = data.consumerConfig
	local v3

	if getFFlagUGCValidationAllowFullVaas() and consumerConfig.isVaaS then
		v3 = consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend
	else
		v3 = v[consumerConfig.source] == true
	end

	local wrapTextureTransfer = rootInstance:FindFirstChildOfClass("WrapTextureTransfer")

	if wrapTextureTransfer == nil then
		error(string.format("WrapTextureTransfer child not found for %s", rootInstance.Name))
	end

	object:setReportingInstance(rootInstance)

	local preloadedEditableImages = data.consumerConfig.preloadedEditableImages

	local v4 = v2[consumerConfig.source] == true

	local decal = Constants.TEXTURE_CONTENT_ID_FIELDS.Decal

	if not decal then
		error("No texture content ID fields defined for Decal class")
	end

	local v5 = nil

	for _, fieldName in decal do
		local v6 = rootInstance[fieldName .. "Content"]

		if not (v6 and v6.Uri ~= nil and v6.Uri ~= "" or v4 and v6 and v6.Object) then
			continue
		end

		local editableInstanceInfo, v7 = createEditableInstancesForContext.getEditableInstanceInfo(
			v6,
			preloadedEditableImages,
			"EditableImage",
			v4
		)

		if editableInstanceInfo and v7 and v7.instance then
			local instance = v7.instance

			if fieldName == "ColorMap" then
				v5 = instance
			end

			local v8 = Constants.MAX_TEXTURE_SIZE

			if getFFlagUGCValidateDecalTextureLimits() and assetType then
				v8 = ConstantsInterface.getTextureLimit(assetType, rootInstance, fieldName)
			end

			validateTextureSize(object, instance, rootInstance:GetFullName() .. "." .. fieldName, fieldName, v8, v3)
		else
			if v3 then
				object:forceError(string.format("Failed to load %s for Decal %s", fieldName, rootInstance.Name))
			end

			object:fail(ErrorSourceStrings.Keys.MakeupDecal_FailedToLoadTexture, {
				fieldName = fieldName,
				instanceName = rootInstance.Name
			})
		end
	end

	if not v5 then
		object:fail(ErrorSourceStrings.Keys.MakeupDecal_NoColorMap, {
			instanceName = rootInstance.Name
		})

		return
	end

	local assetUVBound = Constants.MAKEUP_INFO.AssetUVBounds[assetType]

	if assetUVBound then
		validateUVZones(object, rootInstance, v5, wrapTextureTransfer, assetUVBound, assetType.Name)
	end
end

return MakeupDecalValid
