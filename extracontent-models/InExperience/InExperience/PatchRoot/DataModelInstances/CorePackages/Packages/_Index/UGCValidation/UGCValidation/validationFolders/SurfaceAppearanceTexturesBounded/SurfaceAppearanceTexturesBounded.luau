local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local ConstantsInterface = require(parent.ConstantsInterface)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local FetchAllDesiredData = require(parent.validationSystem.dataFetchModules.FetchAllDesiredData)

local v = {
	ColorMap = game:DefineFastInt("AccessoryColorMapMaxSize", 1024),
	MetalnessMap = game:DefineFastInt("AccessoryMetalnessMapMaxSize", 256),
	NormalMap = game:DefineFastInt("AccessoryNormalMapMaxSize", 256),
	RoughnessMap = game:DefineFastInt("AccessoryRoughnessMapMaxSize", 256)
}

return {
	categories = {
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH
	},
	requiredData = {},
	conditionalData = { ValidationEnums.SharedDataMember.meshTextures },
	expectedFailures = {},
	run = function(object, data)
		local rootInstance = data.rootInstance
		local assetType = data.uploadEnum.assetType
		local meshTextures = data.meshTextures
		local consumerConfig = data.consumerConfig

		if not meshTextures or meshTextures == FetchAllDesiredData.DATA_FETCH_FAILURE then
			object:fetchError("Failed to load texture data for surface appearance texture bounds check")
			return
		end

		local v2 = consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend

		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, rootInstance)

		for _, part in descendants do
			if not part:IsA("MeshPart") then
				continue
			end

			local surfaceAppearance = part:FindFirstChildWhichIsA("SurfaceAppearance")

			if not surfaceAppearance then
				continue
			end

			local meshTexture = meshTextures[part.Name]

			if not (meshTexture and meshTexture.isPBR) then
				continue
			end

			for _, fieldName in {
				"ColorMap",
				"MetalnessMap",
				"NormalMap",
				"RoughnessMap",
				"EmissiveMask"
			} do
				local v3 = meshTexture[fieldName]

				if not (v3 and v3.editable) then
					continue
				end

				local v4

				if assetType then
					v4 = ConstantsInterface.getTextureLimit(assetType, surfaceAppearance, fieldName)
				else
					v4 = v[fieldName]
				end

				local success, result = pcall(function()
					return UGCValidationService:GetEditableImageSize(v3.editable)
				end)

				if success then
					if v4 < result.X or v4 < result.Y then
						object:fail(ErrorSourceStrings.Keys.TextureSize_TooBig, {
							Width = tostring(result.X),
							Height = tostring(result.Y),
							FullName = surfaceAppearance:GetFullName() .. "." .. fieldName,
							MaxSize = tostring(v4),
							FieldName = fieldName
						}, surfaceAppearance)
					end
				else
					if v2 then
						object:fetchError(string.format(
							"Failed to get texture size for '%s'. Make sure the texture exists and try again.",
							surfaceAppearance:GetFullName() .. "." .. fieldName
						))
					end

					object:fail(ErrorSourceStrings.Keys.TextureSize_FailedToLoad, {
						FullName = surfaceAppearance:GetFullName() .. "." .. fieldName
					}, surfaceAppearance)
				end
			end
		end
	end
}
