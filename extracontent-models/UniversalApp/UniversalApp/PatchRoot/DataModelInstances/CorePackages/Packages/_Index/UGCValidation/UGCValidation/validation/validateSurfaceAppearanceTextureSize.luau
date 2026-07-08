local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local ConstantsInterface = require(ParentParent.ConstantsInterface)

require(ParentParent.util.Types)

local validateTextureSize = require(ParentParent.validation.validateTextureSize)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getEditableImageFromContext = require(ParentParent.util.getEditableImageFromContext)
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local flags = ParentParent.flags
local getFFlagUGCValidateAccessoryAssetSurfaceAppearanceTextureLimits = require(flags.getFFlagUGCValidateAccessoryAssetSurfaceAppearanceTextureLimits)
local v11 = game:DefineFastInt("AccessoryColorMapMaxSize", 1024)
local v12 = game:DefineFastInt("AccessoryMetalnessMapMaxSize", 256)
local v13 = game:DefineFastInt("AccessoryNormalMapMaxSize", 256)
local v14 = game:DefineFastInt("AccessoryRoughnessMapMaxSize", 256)
local t1 = {
	ColorMap = v11,
	MetalnessMap = v12,
	NormalMap = v13,
	RoughnessMap = v14
}

local function validateSurfaceAppearanceTextureSize(p1, p2) -- line: 34
	-- upvalues: FailureReasonsAccumulator (copy), ParseContentIds (copy), Constants (copy), getEditableImageFromContext (copy), getFFlagUGCValidateAccessoryAssetSurfaceAppearanceTextureLimits (copy), ConstantsInterface (copy), t1 (copy), validateTextureSize (copy), Analytics (copy)
	local timestamp = tick()
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	local v21 = FailureReasonsAccumulator.new()

	for _, v23 in descendants do
		if v23:IsA("MeshPart") then
			local SurfaceAppearance = v23:FindFirstChildWhichIsA("SurfaceAppearance")

			if SurfaceAppearance then
				for _, v26 in (ParseContentIds.parse(SurfaceAppearance, Constants.TEXTURE_CONTENT_ID_FIELDS, p2)) do
					local t2 = {
						fullName = v26.instance:GetFullName() .. "." .. v26.fieldName,
						fieldName = v26.fieldName,
						contentId = v26.instance[v26.fieldName]
					}
					local v28, v29 = getEditableImageFromContext(v26.instance, v26.fieldName, p2)

					if not v28 then
						return false, { "Failed to load texture data" }
					end

					t2.editableImage = v29

					local v30 = if not getFFlagUGCValidateAccessoryAssetSurfaceAppearanceTextureLimits() or not p2.assetTypeEnum then t1[v26.fieldName] else ConstantsInterface.getTextureLimit(p2.assetTypeEnum, v26.instance, v26.fieldName)

					v21:updateReasons(validateTextureSize(t2, nil, p2, v30))
				end
			end
		end
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return v21:getFinalResults()
end

return validateSurfaceAppearanceTextureSize
