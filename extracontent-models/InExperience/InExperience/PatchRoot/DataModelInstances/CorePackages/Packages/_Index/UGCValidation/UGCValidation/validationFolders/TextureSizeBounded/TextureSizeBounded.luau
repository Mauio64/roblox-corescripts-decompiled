local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local ConstantsInterface = require(parent.ConstantsInterface)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local FetchAllDesiredData = require(parent.validationSystem.dataFetchModules.FetchAllDesiredData)

local TextureSizeBounded = {}

TextureSizeBounded.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD,
	ValidationEnums.UploadCategory.LAYERED_CLOTHING,
	ValidationEnums.UploadCategory.EYEBROW_EYELASH,
	ValidationEnums.UploadCategory.RIGID_ACCESSORY
}

TextureSizeBounded.requiredData = {}
TextureSizeBounded.conditionalData = { ValidationEnums.SharedDataMember.meshTextures }

TextureSizeBounded.expectedFailures = {}

local function checkEditableImageSize(editable, textureLimit: number, fullName: string, fieldName: string, object, p, consumerConfig)
	local success, result = pcall(function()
		return UGCValidationService:GetEditableImageSize(editable)
	end)

	if success then
		if textureLimit < result.X or textureLimit < result.Y then
			object:fail(ErrorSourceStrings.Keys.TextureSize_TooBig, {
				Width = tostring(result.X),
				Height = tostring(result.Y),
				FullName = fullName,
				MaxSize = tostring(textureLimit),
				FieldName = fieldName
			}, p)
		end
	else
		if consumerConfig and consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend then
			object:fetchError(string.format(
				"Failed to get texture size for '%s'. Make sure the texture exists and try again.",
				fullName
			))
		end

		object:fail(ErrorSourceStrings.Keys.TextureSize_FailedToLoad, { FullName = fullName }, p)
	end
end

function TextureSizeBounded.run(object, data)
	local rootInstance = data.rootInstance
	local assetType = data.uploadEnum.assetType
	local meshTextures = data.meshTextures
	local consumerConfig = data.consumerConfig
	local uploadCategory = data.uploadCategory

	if not meshTextures or meshTextures == FetchAllDesiredData.DATA_FETCH_FAILURE then
		object:fetchError("Failed to load texture data for texture size check")
		return
	end

	local descendants = rootInstance:GetDescendants()
	table.insert(descendants, rootInstance)

	for _, part in descendants do
		local part2 = nil
		local v = ""

		if part:IsA("MeshPart") then
			v = part.Name
			part2 = part
		elseif part:IsA("Part") then
			local specialMesh = part:FindFirstChildOfClass("SpecialMesh")

			if specialMesh then
				v = part.Name
				part2 = specialMesh
			end
		end

		if not part2 then
			continue
		end

		local meshTexture = meshTextures[v]

		if not meshTexture then
			continue
		end

		local v2 = uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS
			or uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD

		if meshTexture.isPBR and v2 then
			local surfaceAppearance = part2:FindFirstChildWhichIsA("SurfaceAppearance")

			if surfaceAppearance then
				for _, v3 in {
					"ColorMap",
					"MetalnessMap",
					"NormalMap",
					"RoughnessMap",
					"EmissiveMask"
				} do
					local v4 = meshTexture[v3]

					if not (v4 and v4.editable) then
						continue
					end

					local textureLimit = ConstantsInterface.getTextureLimit(assetType, surfaceAppearance, v3)
					checkEditableImageSize(
						v4.editable,
						textureLimit,
						surfaceAppearance:GetFullName() .. "." .. v3,
						v3,
						object,
						surfaceAppearance,
						consumerConfig
					)
				end
			end
		elseif not meshTexture.isPBR and meshTexture.Texture and meshTexture.Texture.editable then
			local fieldName = part2:IsA("MeshPart") and "TextureID" or "TextureId"

			local textureLimit = ConstantsInterface.getTextureLimit(assetType, part2, fieldName)
			checkEditableImageSize(
				meshTexture.Texture.editable,
				textureLimit,
				part2:GetFullName(),
				fieldName,
				object,
				part2,
				consumerConfig
			)
		end
	end
end

return TextureSizeBounded
