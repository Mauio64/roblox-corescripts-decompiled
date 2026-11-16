local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)

local util = parent.util
require(util.Types)
local TexturePackUtils = require(util.TexturePackUtils)
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)

local getFFlagUGCValidateTexturePack = require(parent.flags.getFFlagUGCValidateTexturePack)
local getFFlagUGCValidateTexturePackOnRCCOnly = require(parent.flags.getFFlagUGCValidateTexturePackOnRCCOnly)

local function validateTexturePackURL(p, flag: boolean, p2)
	local v = FailureReasonsAccumulator.new()

	local surfaceAppearancesMissingTexturePacks = TexturePackUtils.findSurfaceAppearancesMissingTexturePacks(p, flag)

	for _, surfaceAppearancesMissingTexturePack in surfaceAppearancesMissingTexturePacks do
		v:updateReasons(false, {
			`'{surfaceAppearancesMissingTexturePack:GetFullName()}' has a 'TexturePack' property with an invalid URL. Please fix the URL.`
		})
	end

	if #surfaceAppearancesMissingTexturePacks > 0 then
		Analytics.reportFailure(Analytics.ErrorType.validateTexturePack_InvalidTexturePackURL, nil, p2)
	end

	return v:getFinalResults()
end

local function validateSurfaceAppearanceTexturePackMatch(p, p2)
	local v = FailureReasonsAccumulator.new()
	local v2 = false
	local flag = false

	for _, v3 in TexturePackUtils.findSurfaceAppearancesWithTexturePacks(p) do
		local success, result = pcall(function()
			return UGCValidationService:DoesSurfaceAppearanceMatchTexturePackAsync(v3)
		end)

		if success then
			v:updateReasons(result, {
				`The textures in SurfaceAppearance '{v3:GetFullName()}' do not match those in its TexturePack. Please fix the TexturePack`
			})

			if not v2 then
				v2 = not result
			end
		else
			local formatted = `Failed to download TexturePack for SurfaceAppearance '{v3:GetFullName()}'.`

			if p2.isServer then
				error(formatted)
			end

			v:updateReasons(false, { formatted })
			flag = true
		end
	end

	if flag then
		Analytics.reportFailure(Analytics.ErrorType.validateTexturePack_FailedToDownloadTexturePack, nil, p2)
	end

	if v2 then
		Analytics.reportFailure(Analytics.ErrorType.validateTexturePack_TexturePackMismatch, nil, p2)
	end

	return v:getFinalResults()
end

return {
	validate = function(p, flag: boolean, p2)
		if not getFFlagUGCValidateTexturePack() then
			return true
		end

		local v

		if getFFlagUGCValidateTexturePackOnRCCOnly() then
			v = p2.isServer and true or false
		end

		if p2.allowEditableInstances then
			return true
		end

		local now = tick()
		local v2 = FailureReasonsAccumulator.new()

		if getFFlagUGCValidateTexturePackOnRCCOnly() then
			if v then
				v2:updateReasons(validateTexturePackURL(p, flag, p2))
			end
		else
			v2:updateReasons(validateTexturePackURL(p, flag, p2))
		end

		v2:updateReasons(validateSurfaceAppearanceTexturePackMatch(p, p2))

		Analytics.recordScriptTime(script.Name, now, p2)
		return v2:getFinalResults()
	end
}
