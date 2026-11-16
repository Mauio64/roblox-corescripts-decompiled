local parent = script.Parent.Parent.Parent

local HttpService = game:GetService("HttpService")

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local APIUtil = require(parent.util.APIUtil)

local CurveAnimBonesAllowed = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.consumerConfig },
	conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }
}

local function checkTrustedCreatorPermission()
	local v = string.format(
		"https://itemconfiguration.%s/v1/permissions/action-allowed-for-item-type?trustedCreatorCheck=true&action=1&assetType=61",
		APIUtil.getBaseDomain()
	)

	local requestAndRetryGet, v2 = APIUtil.requestAndRetryGet(v)

	if not requestAndRetryGet then
		return false, "Failed to check trusted creator permission: " .. tostring(v2)
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(v2)
	end)

	if success then
		return result.isActionAllowed == true, nil
	end

	return false, "Failed to decode permission response"
end

function CurveAnimBonesAllowed.run(object, p)
	local validationEnv = p.consumerConfig.validationEnv

	if validationEnv == ValidationEnums.ValidationEnv.IEC then
		object:fail(ErrorSourceStrings.Keys.CurveAnim_BonesNotAllowed)
	elseif validationEnv == ValidationEnums.ValidationEnv.Backend then
		if not p.consumerConfig.backendConfigs.isUserInTrustedCreatorProgram then
			object:fail(ErrorSourceStrings.Keys.CurveAnim_BonesNotAllowed)
		end
	else
		local v, v2 = checkTrustedCreatorPermission()

		if v2 then
			object:forceError(v2)
		end

		if not v then
			object:fail(ErrorSourceStrings.Keys.CurveAnim_BonesNotAllowed)
		end
	end
end

return CurveAnimBonesAllowed
