local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local ConstantsInterface = require(ParentParent.ConstantsInterface)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local FetchAllDesiredData = require(ParentParent.validationSystem.dataFetchModules.FetchAllDesiredData)
local getFFlagUGCValidateMigrateTextureTransparency = require(ParentParent.flags.getFFlagUGCValidateMigrateTextureTransparency)
local getFFlagUGCValidateAllowEmissives = require(ParentParent.flags.getFFlagUGCValidateAllowEmissives)
local v9 = game:DefineFastInt("AccessoryColorMapMaxSize", 1024)
local v10 = game:DefineFastInt("AccessoryMetalnessMapMaxSize", 256)
local v11 = game:DefineFastInt("AccessoryNormalMapMaxSize", 256)
local v12 = game:DefineFastInt("AccessoryRoughnessMapMaxSize", 256)
local t1 = {
	ColorMap = v9,
	MetalnessMap = v10,
	NormalMap = v11,
	RoughnessMap = v12
}

return {
	categories = {
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING
	},
	requiredData = {},
	conditionalData = { ValidationEnums.SharedDataMember.meshTextures },
	fflag = getFFlagUGCValidateMigrateTextureTransparency,
	expectedFailures = {},
	run = function(p1, p2) -- line: 48
		-- upvalues: FetchAllDesiredData (copy), getFFlagUGCValidateAllowEmissives (copy), ConstantsInterface (copy), t1 (copy), UGCValidationService (copy), ValidationEnums (copy), ErrorSourceStrings (copy)
		local rootInstance = p2.rootInstance
		local assetType = p2.uploadEnum.assetType
		local meshTextures = p2.meshTextures
		local consumerConfig = p2.consumerConfig

		if not meshTextures or meshTextures == FetchAllDesiredData.DATA_FETCH_FAILURE then
			p1:fetchError("Failed to load texture data for surface appearance texture bounds check")

			return
		end

		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, rootInstance)

		for _, v22 in descendants do
			if v22:IsA("MeshPart") then
				local SurfaceAppearance = v22:FindFirstChildWhichIsA("SurfaceAppearance")

				if SurfaceAppearance then
					local v24 = meshTextures[v22.Name]

					if v24 and v24.isPBR then
						local t2 = {
							"ColorMap",
							"MetalnessMap",
							"NormalMap",
							"RoughnessMap"
						}

						if getFFlagUGCValidateAllowEmissives() then
							table.insert(t2, "EmissiveMask")
						end

						for _, v27 in t2 do
							local v28 = v24[v27]

							if v28 and v28.editable then
								local v29 = if not assetType then t1[v27] else ConstantsInterface.getTextureLimit(assetType, SurfaceAppearance, v27)
								local ok, result = pcall(function() -- line: 96
									-- upvalues: UGCValidationService (copy), v28 (copy)
									return UGCValidationService:GetEditableImageSize(v28.editable)
								end)

								if not ok then
									if consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend then
										p1:fetchError(string.format("Failed to get texture size for '%s'. Make sure the texture exists and try again.", SurfaceAppearance:GetFullName() .. "." .. v27))
									end

									p1:fail(ErrorSourceStrings.Keys.TextureSize_FailedToLoad, {
										FullName = SurfaceAppearance:GetFullName() .. "." .. v27
									}, SurfaceAppearance)
								elseif v29 < result.X or v29 < result.Y then
									p1:fail(ErrorSourceStrings.Keys.TextureSize_TooBig, {
										Width = tostring(result.X),
										Height = tostring(result.Y),
										FullName = SurfaceAppearance:GetFullName() .. "." .. v27,
										MaxSize = tostring(v29),
										FieldName = v27
									}, SurfaceAppearance)
								end
							end
						end
					end
				end
			end
		end
	end
}
