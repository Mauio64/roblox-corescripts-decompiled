local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local ConstantsInterface = require(ParentParent.ConstantsInterface)

require(ParentParent.util.Types)

local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getEditableImageFromContext = require(ParentParent.util.getEditableImageFromContext)
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local validateMakeupDecalUVZones = require(ParentParent.validation.validateMakeupDecalUVZones)
local getFFlagUGCValidateDecalTextureLimits = require(ParentParent.flags.getFFlagUGCValidateDecalTextureLimits)
local validateTextureSize = require(ParentParent.validation.validateTextureSize)

local function validateMakeupDecal(p1, p2) -- line: 23
	-- upvalues: FailureReasonsAccumulator (copy), ParseContentIds (copy), Constants (copy), getEditableImageFromContext (copy), Analytics (copy), getFFlagUGCValidateDecalTextureLimits (copy), ConstantsInterface (copy), validateTextureSize (copy), validateMakeupDecalUVZones (copy)
	local timestamp = tick()
	local assetTypeEnum = p2.assetTypeEnum
	local WrapTextureTransfer = p1:FindFirstChildOfClass("WrapTextureTransfer")

	assert(WrapTextureTransfer ~= nil, string.format("WrapTextureTransfer child not found for %s", p1.Name))

	local v17 = FailureReasonsAccumulator.new()
	local v18 = nil

	for _, v20 in (ParseContentIds.parse(p1, Constants.TEXTURE_CONTENT_ID_FIELDS, p2)) do
		local t1 = {
			fullName = v20.instance:GetFullName() .. "." .. v20.fieldName,
			fieldName = v20.fieldName,
			contentId = v20.instance[v20.fieldName]
		}
		local v22, v23 = getEditableImageFromContext(v20.instance, v20.fieldName, p2)

		if not v22 then
			Analytics.reportFailure(Analytics.ErrorType.validateMakeupDecal_FailedToLoadTexture, nil, p2)
			v17:updateReasons(false, { string.format("Failed to load %s for Decal %s. Make sure TextureContent exists and is valid and try again.", t1.fieldName, p1.Name) })
		end

		t1.editableImage = v23

		if v20.fieldName == "ColorMap" then
			v18 = v23
		end

		local v24 = nil

		if getFFlagUGCValidateDecalTextureLimits() and assetTypeEnum then
			v24 = ConstantsInterface.getTextureLimit(assetTypeEnum, v20.instance, v20.fieldName)
		end

		v17:updateReasons(validateTextureSize(t1, nil, p2, v24))
	end

	if not v18 then
		Analytics.reportFailure(Analytics.ErrorType.validateMakeupDecal_NoColorMap, nil, p2)

		return false, { string.format("No ColorMap found for Decal %s. Makeup Decals are required to have a valid ColorMap.", p1.Name) }
	end

	v17:updateReasons(validateMakeupDecalUVZones(p1, v18, WrapTextureTransfer, Constants.MAKEUP_INFO.AssetUVBounds[assetTypeEnum], p2))
	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return v17:getFinalResults()
end

return validateMakeupDecal
