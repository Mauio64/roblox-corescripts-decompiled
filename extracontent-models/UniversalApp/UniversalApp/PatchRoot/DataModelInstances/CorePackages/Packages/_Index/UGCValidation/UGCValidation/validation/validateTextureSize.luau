local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local flags = ParentParent.flags
local getFFlagUGCValidateTextureSizeExtraErrorInfo = require(flags.getFFlagUGCValidateTextureSizeExtraErrorInfo)
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)

local function validateTextureSize(p1, b1: boolean?, p2, n1: number?) -- line: 14
	-- upvalues: Constants (copy), Analytics (copy), pcallDeferred (copy), UGCValidationService (copy), getFFlagUGCValidateTextureSizeExtraErrorInfo (copy)
	local timestamp = tick()
	local isServer = p2.isServer

	if not n1 then
		n1 = Constants.MAX_TEXTURE_SIZE
	end

	assert(n1, "maxTextureSize is required for validateTextureSize")

	if not p1.editableImage then
		if b1 then
			return true
		end

		Analytics.reportFailure(Analytics.ErrorType.validateTextureSize_InvalidTextureId, nil, p2)

		return false, { string.format("Invalid textureID used in mesh '%s'. Make sure the texture exists and try again.", p1.fullName) }
	end

	local v15, v16 = pcallDeferred(function() -- line: 41
		-- upvalues: UGCValidationService (copy), p1 (copy)
		return UGCValidationService:GetEditableImageSize(p1.editableImage)
	end, p2)

	if not v15 then
		if isServer ~= nil and isServer then
			error(string.format("Failed to load texture data for '%s'. Make sure the texture exists and try again.", p1.fullName))
		end

		Analytics.reportFailure(Analytics.ErrorType.validateTextureSize_FailedToLoadTexture, nil, p2)

		return false, { string.format("Failed to load texture data for '%s'. Make sure the texture exists and try again.", p1.fullName) }
	end

	if n1 < v16.X or n1 < v16.Y then
		Analytics.reportFailure(Analytics.ErrorType.validateTextureSize_TextureTooBig, nil, p2)

		local v17 = n1 ~= Constants.MAX_TEXTURE_SIZE

		if getFFlagUGCValidateTextureSizeExtraErrorInfo() or v17 then
			return false, { string.format("Texture resolution %dx%d px found in '%s' is higher than max size supported value of %dx%d px for field '%s'.", v16.X, v16.Y, p1.fullName, n1, n1, p1.fieldName) }
		end

		return false, { string.format("Texture resolution %dx%d px found in '%s' is higher than max size supported value of %dx%d px. You need to reduce the texture resolution", v16.X, v16.Y, p1.fullName, n1, n1) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return true
end

return validateTextureSize
