local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)
local ConstantsInterface = require(ParentParent.ConstantsInterface)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local createEditableInstancesForContext = require(ParentParent.util.createEditableInstancesForContext)
local getFFlagUGCValidateMigrateWrapAndMakeup = require(ParentParent.flags.getFFlagUGCValidateMigrateWrapAndMakeup)
local getFFlagUGCValidateDecalTextureLimits = require(ParentParent.flags.getFFlagUGCValidateDecalTextureLimits)
local v10 = game:DefineFastInt("ValidateMakeupZoneIncludeToleranceHundredthsPercent", 100)
local v11 = game:DefineFastInt("ValidateMakeupZoneExcludeHundredthsPercent", 200)
local t1 = {
	Publish = true,
	Backend = true,
	Internal = true,
	InExpServer = true
}
local t2 = {
	InExpServer = true,
	InExpClient = true
}
local t3 = {
	fflag = getFFlagUGCValidateMigrateWrapAndMakeup,
	categories = { ValidationEnums.UploadCategory.MAKEUP },
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	expectedFailures = {}
}

local function validateTextureSize(p1, p2, s1: string, s2: string, n1: number, b1: boolean) -- line: 52
	-- upvalues: UGCValidationService (copy), ErrorSourceStrings (copy)
	local ok, result = pcall(function() -- line: 60
		-- upvalues: UGCValidationService (copy), p2 (copy)
		return UGCValidationService:GetEditableImageSize(p2)
	end)

	if not ok then
		if b1 then
			p1:forceError(string.format("Failed to load texture data for '%s'. Make sure the texture exists and try again.", s1))
		end

		p1:fail(ErrorSourceStrings.Keys.MakeupDecal_FailedToLoadTextureData, {
			fullName = s1
		})

		return
	end

	if n1 < result.X or n1 < result.Y then
		p1:fail(ErrorSourceStrings.Keys.MakeupDecal_TextureTooBig, {
			sizeX = tostring(result.X),
			sizeY = tostring(result.Y),
			fullName = s1,
			maxSize = tostring(n1),
			fieldName = s2
		})
	end
end
local function validateCoverageOutsideIncludeBounds(p3, p4, p5, vector2: Vector2, vector2_2: Vector2, p6, s3: string) -- line: 91
	-- upvalues: v10 (copy), ErrorSourceStrings (copy)
	local v34 = (vector2_2.X - vector2.X) * (vector2_2.Y - vector2.Y) * v10 / 10000 * 255
	local n2 = 0
	local v36 = p5:ReadPixelsBuffer(Vector2.new(0, 0), p5.Size)
	local n3 = 0
	local v38 = p5.Size.Y - 1

	for i = 0, buffer.len(v36) - 1, 4 do
		if n3 == p5.Size.X then
			n3 = 0
			v38 -= 1
		end

		local v40 = buffer.readu8(v36, i + 3)

		if v40 > 0 and (n3 < vector2.X or v38 < vector2.Y or n3 > vector2_2.X or v38 > vector2_2.Y) then
			n2 += v40
		end

		n3 += 1
	end

	if v34 < n2 then
		p3:fail(ErrorSourceStrings.Keys.MakeupDecal_UVZoneIncludeViolation, {
			instanceName = p4.Name,
			minBound = tostring(p6.MinBound),
			maxBound = tostring(p6.MaxBound),
			assetTypeName = s3
		})
	end
end
local function validateCoverageInsideExcludeBounds(p7, p8, p9, vector2: Vector2, vector2_3: Vector2, p10, s4: string) -- line: 137
	-- upvalues: v11 (copy), ErrorSourceStrings (copy)
	local v48 = (vector2_3.X - vector2.X) * (vector2_3.Y - vector2.Y) * v11 / 10000 * 255
	local n4 = 0
	local v50 = p9:ReadPixelsBuffer(Vector2.new(0, 0), p9.Size)
	local n5 = 0
	local v52 = p9.Size.Y - 1

	for i = 0, buffer.len(v50) - 1, 4 do
		if n5 == p9.Size.X then
			n5 = 0
			v52 -= 1
		end

		local v54 = buffer.readu8(v50, i + 3)

		if v54 > 0 and n5 > vector2.X and v52 > vector2.Y and n5 < vector2_3.X and v52 < vector2_3.Y then
			n4 += v54
		end

		n5 += 1
	end

	if v48 < n4 then
		p7:fail(ErrorSourceStrings.Keys.MakeupDecal_UVZoneExcludeViolation, {
			instanceName = p8.Name,
			minBound = tostring(p10.MinBound),
			maxBound = tostring(p10.MaxBound),
			assetTypeName = s4
		})
	end
end
local function validateUVZones(p11, p12, p13, p14, p15, s5: string) -- line: 183
	-- upvalues: validateCoverageOutsideIncludeBounds (copy), validateCoverageInsideExcludeBounds (copy)
	local v61 = p14.UVMaxBound - p14.UVMinBound

	for _, v63 in p15 do
		local v64 = (v63.MinBound - p14.UVMinBound) / v61
		local v65 = (v63.MaxBound - p14.UVMinBound) / v61
		local v66 = v64 * p13.Size
		local v67 = v65 * p13.Size

		if v63.isIncludeBound then
			validateCoverageOutsideIncludeBounds(p11, p12, p13, v66, v67, v63, s5)
		else
			validateCoverageInsideExcludeBounds(p11, p12, p13, v66, v67, v63, s5)
		end
	end
end

function t3.run(p16, p17) -- line: 224
	-- upvalues: t1 (copy), t2 (copy), Constants (copy), createEditableInstancesForContext (copy), ErrorSourceStrings (copy), getFFlagUGCValidateDecalTextureLimits (copy), ConstantsInterface (copy), validateTextureSize (copy), validateUVZones (copy)
	local rootInstance = p17.rootInstance
	local assetType = p17.uploadEnum.assetType
	local v72 = t1[p17.consumerConfig.source] == true
	local WrapTextureTransfer = rootInstance:FindFirstChildOfClass("WrapTextureTransfer")

	if WrapTextureTransfer == nil then
		error(string.format("WrapTextureTransfer child not found for %s", rootInstance.Name))
	end

	p16:setReportingInstance(rootInstance)

	local preloadedEditableImages = p17.consumerConfig.preloadedEditableImages
	local v75 = t2[p17.consumerConfig.source] == true
	local Decal = Constants.TEXTURE_CONTENT_ID_FIELDS.Decal

	if not Decal then
		error("No texture content ID fields defined for Decal class")
	end

	local v77 = nil

	for _, v79 in Decal do
		local v80 = rootInstance[v79 .. "Content"]

		if v80 and v80.Uri ~= nil and v80.Uri ~= "" or v75 and v80 and v80.Object then
			local v81, v82 = createEditableInstancesForContext.getEditableInstanceInfo(v80, preloadedEditableImages, "EditableImage", v75)

			if not v81 or not v82 or not v82.instance then
				if v72 then
					p16:forceError(string.format("Failed to load %s for Decal %s", v79, rootInstance.Name))
				end

				p16:fail(ErrorSourceStrings.Keys.MakeupDecal_FailedToLoadTexture, {
					fieldName = v79,
					instanceName = rootInstance.Name
				})
			else
				local instance = v82.instance

				if v79 == "ColorMap" then
					v77 = instance
				end

				local MAX_TEXTURE_SIZE = Constants.MAX_TEXTURE_SIZE

				if getFFlagUGCValidateDecalTextureLimits() and assetType then
					MAX_TEXTURE_SIZE = ConstantsInterface.getTextureLimit(assetType, rootInstance, v79)
				end

				local v85 = rootInstance:GetFullName() .. "." .. v79

				validateTextureSize(p16, instance, v85, v79, MAX_TEXTURE_SIZE, v72)
			end
		end
	end

	if not v77 then
		p16:fail(ErrorSourceStrings.Keys.MakeupDecal_NoColorMap, {
			instanceName = rootInstance.Name
		})

		return
	end

	local v86 = Constants.MAKEUP_INFO.AssetUVBounds[assetType]

	if v86 then
		validateUVZones(p16, rootInstance, v77, WrapTextureTransfer, v86, assetType.Name)
	end
end

return t3
