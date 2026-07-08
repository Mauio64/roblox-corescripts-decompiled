local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local util = ParentParent.util

require(util.Types)

local TexturePackUtils = require(util.TexturePackUtils)
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
local getFFlagUGCValidateTexturePack = require(ParentParent.flags.getFFlagUGCValidateTexturePack)
local getFFlagUGCValidateTexturePackOnRCCOnly = require(ParentParent.flags.getFFlagUGCValidateTexturePackOnRCCOnly)
local t1 = {}

local function validateTexturePackURL(p1, b1: boolean, p2) -- line: 21
	-- upvalues: FailureReasonsAccumulator (copy), TexturePackUtils (copy), Analytics (copy)
	local v15 = FailureReasonsAccumulator.new()
	local v16 = TexturePackUtils.findSurfaceAppearancesMissingTexturePacks(p1, b1)

	for _, v18 in v16 do
		v15:updateReasons(false, { `'{ v18:GetFullName() }' has a 'TexturePack' property with an invalid URL. Please fix the URL.` })
	end

	if #v16 > 0 then
		Analytics.reportFailure(Analytics.ErrorType.validateTexturePack_InvalidTexturePackURL, nil, p2)
	end

	return v15:getFinalResults()
end
local function validateSurfaceAppearanceTexturePackMatch(p3, p4) -- line: 41
	-- upvalues: FailureReasonsAccumulator (copy), TexturePackUtils (copy), UGCValidationService (copy), Analytics (copy)
	local v21 = FailureReasonsAccumulator.new()
	local v22 = false
	local v23 = false

	for _, v25 in TexturePackUtils.findSurfaceAppearancesWithTexturePacks(p3) do
		local ok, result = pcall(function() -- line: 49
			-- upvalues: UGCValidationService (copy), v25 (copy)
			return UGCValidationService:DoesSurfaceAppearanceMatchTexturePackAsync(v25)
		end)

		if not ok then
			local v28 = `Failed to download TexturePack for SurfaceAppearance '{ v25:GetFullName() }'.`

			if p4.isServer then
				error(v28)
			end

			v23 = true
			v21:updateReasons(false, { v28 })
		else
			v21:updateReasons(result, { `The textures in SurfaceAppearance '{ v25:GetFullName() }' do not match those in its TexturePack. Please fix the TexturePack` })

			if not v22 then
				v22 = not result
			end
		end
	end

	if v23 then
		Analytics.reportFailure(Analytics.ErrorType.validateTexturePack_FailedToDownloadTexturePack, nil, p4)
	end

	if v22 then
		Analytics.reportFailure(Analytics.ErrorType.validateTexturePack_TexturePackMismatch, nil, p4)
	end

	return v21:getFinalResults()
end

function t1.validate(p5, b2: boolean, p6) -- line: 82
	-- upvalues: getFFlagUGCValidateTexturePack (copy), getFFlagUGCValidateTexturePackOnRCCOnly (copy), FailureReasonsAccumulator (copy), validateTexturePackURL (copy), validateSurfaceAppearanceTexturePackMatch (copy), Analytics (copy)
	if not getFFlagUGCValidateTexturePack() then
		return true
	end

	local v32 = nil

	if getFFlagUGCValidateTexturePackOnRCCOnly() then
		v32 = not not p6.isServer
	end

	if p6.allowEditableInstances then
		return true
	end

	local timestamp = tick()
	local v34 = FailureReasonsAccumulator.new()

	if getFFlagUGCValidateTexturePackOnRCCOnly() then
		if v32 then
			v34:updateReasons(validateTexturePackURL(p5, b2, p6))
		end
	else
		v34:updateReasons(validateTexturePackURL(p5, b2, p6))
	end

	v34:updateReasons(validateSurfaceAppearanceTexturePackMatch(p5, p6))
	Analytics.recordScriptTime(script.Name, timestamp, p6)

	return v34:getFinalResults()
end

return t1
