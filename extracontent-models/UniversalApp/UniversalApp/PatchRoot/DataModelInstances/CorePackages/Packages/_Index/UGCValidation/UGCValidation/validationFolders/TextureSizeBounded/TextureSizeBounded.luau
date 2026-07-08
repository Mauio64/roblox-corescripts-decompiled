local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local ConstantsInterface = require(ParentParent.ConstantsInterface)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local FetchAllDesiredData = require(ParentParent.validationSystem.dataFetchModules.FetchAllDesiredData)
local getFFlagUGCValidateMigrateTextureTransparency = require(ParentParent.flags.getFFlagUGCValidateMigrateTextureTransparency)
local getFFlagUGCValidateAllowEmissives = require(ParentParent.flags.getFFlagUGCValidateAllowEmissives)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = {},
	conditionalData = { ValidationEnums.SharedDataMember.meshTextures },
	fflag = getFFlagUGCValidateMigrateTextureTransparency,
	expectedFailures = {}
}

local function checkEditableImageSize(p1, n1: number, s1: string, s2: string, p2, p3, p4) -- line: 32
	-- upvalues: UGCValidationService (copy), ValidationEnums (copy), ErrorSourceStrings (copy)
	local ok, result = pcall(function() -- line: 41
		-- upvalues: UGCValidationService (copy), p1 (copy)
		return UGCValidationService:GetEditableImageSize(p1)
	end)

	if not ok then
		if p4 and p4.consumerEnv == ValidationEnums.ConsumerEnv.Backend then
			p2:fetchError(string.format("Failed to get texture size for '%s'. Make sure the texture exists and try again.", s1))
		end

		p2:fail(ErrorSourceStrings.Keys.TextureSize_FailedToLoad, {
			FullName = s1
		}, p3)

		return
	end

	if n1 < result.X or n1 < result.Y then
		p2:fail(ErrorSourceStrings.Keys.TextureSize_TooBig, {
			Width = tostring(result.X),
			Height = tostring(result.Y),
			FullName = s1,
			MaxSize = tostring(n1),
			FieldName = s2
		}, p3)
	end
end

function t1.run(p5, p6) -- line: 71
	-- upvalues: FetchAllDesiredData (copy), ValidationEnums (copy), getFFlagUGCValidateAllowEmissives (copy), ConstantsInterface (copy), checkEditableImageSize (copy)
	local rootInstance = p6.rootInstance
	local assetType = p6.uploadEnum.assetType
	local meshTextures = p6.meshTextures
	local consumerConfig = p6.consumerConfig
	local uploadCategory = p6.uploadCategory

	if not meshTextures or meshTextures == FetchAllDesiredData.DATA_FETCH_FAILURE then
		p5:fetchError("Failed to load texture data for texture size check")

		return
	end

	local descendants = rootInstance:GetDescendants()

	table.insert(descendants, rootInstance)

	for _, v29 in descendants do
		local v30 = nil
		local s3 = ""

		if v29:IsA("MeshPart") then
			v30 = v29
			s3 = v29.Name
		elseif v29:IsA("Part") then
			local SpecialMesh = v29:FindFirstChildOfClass("SpecialMesh")

			if SpecialMesh then
				v30 = SpecialMesh
				s3 = v29.Name
			end
		end

		if v30 then
			local v33 = meshTextures[s3]

			if v33 then
				local v34 = uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS or uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD

				if v33.isPBR and v34 then
					local SurfaceAppearance = v30:FindFirstChildWhichIsA("SurfaceAppearance")

					if SurfaceAppearance then
						local t2 = {
							"ColorMap",
							"MetalnessMap",
							"NormalMap",
							"RoughnessMap"
						}

						if getFFlagUGCValidateAllowEmissives() then
							table.insert(t2, "EmissiveMask")
						end

						for _, v38 in t2 do
							local v39 = v33[v38]

							if v39 and v39.editable then
								local v40 = ConstantsInterface.getTextureLimit(assetType, SurfaceAppearance, v38)

								checkEditableImageSize(v39.editable, v40, SurfaceAppearance:GetFullName() .. "." .. v38, v38, p5, SurfaceAppearance, consumerConfig)
							end
						end
					end
				elseif not v33.isPBR and v33.Texture and v33.Texture.editable then
					local v41 = not v30:IsA("MeshPart") and "TextureId" or "TextureID"
					local v42 = ConstantsInterface.getTextureLimit(assetType, v30, v41)

					checkEditableImageSize(v33.Texture.editable, v42, v30:GetFullName(), v41, p5, v30, consumerConfig)
				end
			end
		end
	end
end

return t1
