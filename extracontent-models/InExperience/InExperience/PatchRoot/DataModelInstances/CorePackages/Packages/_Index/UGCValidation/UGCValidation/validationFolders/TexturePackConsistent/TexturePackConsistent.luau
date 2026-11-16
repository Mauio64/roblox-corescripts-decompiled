local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local TexturePackUtils = require(parent.util.TexturePackUtils)

local getFFlagUGCValidateTexturePack = require(parent.flags.getFFlagUGCValidateTexturePack)
local getFFlagUGCValidateTexturePackOnRCCOnly = require(parent.flags.getFFlagUGCValidateTexturePackOnRCCOnly)
local getFFlagUGCValidationAllowFullVaas = require(parent.flags.getFFlagUGCValidationAllowFullVaas)

local v = { Publish = true, Backend = true, InExpServer = true, Internal = true }

local v2 = { InExpServer = true, InExpClient = true }

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = {},
	expectedFailures = {},
	run = function(object, data)
		if not getFFlagUGCValidateTexturePack() then
			return
		end

		local rootInstance = data.rootInstance
		local consumerConfig = data.consumerConfig

		if v2[consumerConfig.source] == true then
			return
		end

		local v3

		if getFFlagUGCValidationAllowFullVaas() and consumerConfig.isVaaS then
			v3 = consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend
		else
			v3 = v[consumerConfig.source] == true
		end

		local uploadCategory = data.uploadCategory
		local v4 = uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS
			or uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD

		if getFFlagUGCValidateTexturePackOnRCCOnly() then
			if v3 then
				local surfaceAppearancesMissingTexturePacks = TexturePackUtils.findSurfaceAppearancesMissingTexturePacks(
					rootInstance,
					v4
				)

				for _, surfaceAppearancesMissingTexturePack in surfaceAppearancesMissingTexturePacks do
					object:fail(
						ErrorSourceStrings.Keys.TexturePackInvalidURL,
						{
							SurfaceAppearanceName = surfaceAppearancesMissingTexturePack:GetFullName()
						},
						surfaceAppearancesMissingTexturePack
					)
				end
			end
		else
			local surfaceAppearancesMissingTexturePacks = TexturePackUtils.findSurfaceAppearancesMissingTexturePacks(
				rootInstance,
				v4
			)

			for _, surfaceAppearancesMissingTexturePack in surfaceAppearancesMissingTexturePacks do
				object:fail(
					ErrorSourceStrings.Keys.TexturePackInvalidURL,
					{
						SurfaceAppearanceName = surfaceAppearancesMissingTexturePack:GetFullName()
					},
					surfaceAppearancesMissingTexturePack
				)
			end
		end

		for _, v5 in TexturePackUtils.findSurfaceAppearancesWithTexturePacks(rootInstance) do
			local success, result = pcall(function()
				return UGCValidationService:DoesSurfaceAppearanceMatchTexturePackAsync(v5)
			end)

			if success then
				if not result then
					object:fail(
						ErrorSourceStrings.Keys.TexturePack_Mismatch,
						{ SurfaceAppearanceName = v5:GetFullName() },
						v5
					)
				end
			else
				if v3 then
					object:forceError(`Failed to download TexturePack for SurfaceAppearance '{v5:GetFullName()}'.`)
				end

				object:fail(
					ErrorSourceStrings.Keys.TexturePack_DownloadFailed,
					{ SurfaceAppearanceName = v5:GetFullName() },
					v5
				)
			end
		end
	end
}
