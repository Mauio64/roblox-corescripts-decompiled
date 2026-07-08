local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local TexturePackUtils = require(ParentParent.util.TexturePackUtils)
local getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality = require(ParentParent.flags.getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality)
local getFFlagUGCValidateTexturePack = require(ParentParent.flags.getFFlagUGCValidateTexturePack)
local getFFlagUGCValidateTexturePackOnRCCOnly = require(ParentParent.flags.getFFlagUGCValidateTexturePackOnRCCOnly)
local t1 = {
	Publish = true,
	Backend = true,
	InExpServer = true,
	Internal = true
}
local t2 = {
	InExpServer = true,
	InExpClient = true
}

return {
	fflag = getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality,
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = {},
	expectedFailures = {},
	run = function(p1, p2) -- line: 51
		-- upvalues: getFFlagUGCValidateTexturePack (copy), t2 (copy), t1 (copy), ValidationEnums (copy), getFFlagUGCValidateTexturePackOnRCCOnly (copy), TexturePackUtils (copy), ErrorSourceStrings (copy), UGCValidationService (copy)
		if not getFFlagUGCValidateTexturePack() then
			return
		end

		local rootInstance = p2.rootInstance
		local source = p2.consumerConfig.source

		if t2[source] == true then
			return
		end

		local v15 = t1[source] == true
		local uploadCategory = p2.uploadCategory
		local v17 = uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS or uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD

		if getFFlagUGCValidateTexturePackOnRCCOnly() then
			if v15 then
				for _, v19 in (TexturePackUtils.findSurfaceAppearancesMissingTexturePacks(rootInstance, v17)) do
					p1:fail(ErrorSourceStrings.Keys.TexturePackInvalidURL, {
						SurfaceAppearanceName = v19:GetFullName()
					}, v19)
				end
			end
		else
			for _, v21 in (TexturePackUtils.findSurfaceAppearancesMissingTexturePacks(rootInstance, v17)) do
				p1:fail(ErrorSourceStrings.Keys.TexturePackInvalidURL, {
					SurfaceAppearanceName = v21:GetFullName()
				}, v21)
			end
		end

		for _, v23 in TexturePackUtils.findSurfaceAppearancesWithTexturePacks(rootInstance) do
			local ok, result = pcall(function() -- line: 91
				-- upvalues: UGCValidationService (copy), v23 (copy)
				return UGCValidationService:DoesSurfaceAppearanceMatchTexturePackAsync(v23)
			end)

			if not ok then
				if v15 then
					p1:forceError(`Failed to download TexturePack for SurfaceAppearance '{ v23:GetFullName() }'.`)
				end

				p1:fail(ErrorSourceStrings.Keys.TexturePack_DownloadFailed, {
					SurfaceAppearanceName = v23:GetFullName()
				}, v23)
			elseif not result then
				p1:fail(ErrorSourceStrings.Keys.TexturePack_Mismatch, {
					SurfaceAppearanceName = v23:GetFullName()
				}, v23)
			end
		end
	end
}
