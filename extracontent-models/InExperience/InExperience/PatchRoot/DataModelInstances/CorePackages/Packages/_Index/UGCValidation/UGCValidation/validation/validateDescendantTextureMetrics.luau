local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Constants = require(ParentParent.Constants)
local ConstantsInterface = require(ParentParent.ConstantsInterface)
local validateTextureSize = require(ParentParent.validation.validateTextureSize)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local getEditableImageFromContext = require(ParentParent.util.getEditableImageFromContext)
local flags = ParentParent.flags
local getFFlagUGCValidateBodyAssetTextureLimits = require(flags.getFFlagUGCValidateBodyAssetTextureLimits)

local function validateDescendantTextureMetrics(p1, p2) -- line: 20
	-- upvalues: FailureReasonsAccumulator (copy), ParseContentIds (copy), Constants (copy), getEditableImageFromContext (copy), getFFlagUGCValidateBodyAssetTextureLimits (copy), ConstantsInterface (copy), validateTextureSize (copy)
	local v13 = FailureReasonsAccumulator.new()
	local t1 = {}

	for _, v16 in (ParseContentIds.parse(p1, Constants.TEXTURE_CONTENT_ID_FIELDS, p2)) do
		local t2 = {
			fullName = v16.instance:GetFullName(),
			fieldName = v16.fieldName,
			contentId = v16.instance[v16.fieldName]
		}
		local v18, v19 = getEditableImageFromContext(v16.instance, v16.fieldName, p2)

		if not v18 then
			return false, { "Failed to load texture data" }
		end

		t2.editableImage = v19

		if not t1[v16.id] then
			local v20 = nil

			if getFFlagUGCValidateBodyAssetTextureLimits() then
				v20 = ConstantsInterface.getTextureLimit(p2.assetTypeEnum, v16.instance, v16.fieldName)
			end

			v13:updateReasons(validateTextureSize(t2, nil, p2, v20))

			if v16.id then
				t1[v16.id] = true
			end
		end
	end

	return v13:getFinalResults()
end

return validateDescendantTextureMetrics
