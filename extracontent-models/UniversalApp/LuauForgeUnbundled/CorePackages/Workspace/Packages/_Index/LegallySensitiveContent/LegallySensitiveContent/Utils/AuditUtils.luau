local CryptoUtils = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Utils/CryptoUtils")
local LegallySensitiveContentConstants = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Constants/LegallySensitiveContentConstants")
local base64 = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/dependencies").Base64
local ConsentName = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Enums/ConsentName")

require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Types/LegallySensitiveContentTypes")

local function getAuditDataForConsent(p2, data)
	local v6 = ({
		[ConsentName.phoneNumberDiscoverabilityUpsell] = {
			{
				consentStringTemplate = data.phoneNumberDiscoverabilityUpsellNotNow,
				sourceContentId = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.notNowSourceContentId
			},
			{
				consentStringTemplate = data.phoneNumberDiscoverabilityUpsellTurnOn,
				sourceContentId = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.turnOnSourceContentId
			},
			{
				consentStringTemplate = data.phoneNumberDiscoverabilityUpsellTitle,
				sourceContentId = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.titleSourceContentId
			},
			{
				consentStringTemplate = data.phoneNumberDiscoverabilityUpsellContent,
				sourceContentId = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.contentSourceContentId
			}
		},
		[ConsentName.PhotoToAvatar] = {
			{
				consentStringTemplate = data.photoToAvatarTitle,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.titleSourceContentId
			},
			{
				consentStringTemplate = data.photoToAvatarBodyText,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.bodyTextSourceContentId
			},
			{
				consentStringTemplate = data.photoToAvatarPrivacyLinkText,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.privacyLinkTextSourceContentId
			},
			{
				consentStringTemplate = data.photoToAvatarAgreeButton,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.agreeButtonSourceContentId
			},
			{
				consentStringTemplate = data.photoToAvatarCancelButton,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.cancelButtonSourceContentId
			}
		},
		[ConsentName.allowMarketingEmailCheckboxAccountUpgrade] = {
			{
				consentStringTemplate = data.allowMarketingEmailCheckboxAccountUpgradeConsent,
				sourceContentId = LegallySensitiveContentConstants.allowMarketingEmailCheckboxAccountUpgrade.consentSourceContentId
			}
		},
		[ConsentName.allowMarketingEmailAutoOptInAccountUpgrade] = {}
	})[p2]

	if v6 then
		return v6
	end

	return {}
end

local function getAuditHeaderValue(auditDataForConsent, p2, items)
	local v5 = {}

	for i, item in ipairs(auditDataForConsent) do
		local vars = {
			hash = CryptoUtils.hashStringWithFnv1a32(item.consentStringTemplate)
		}

		if item.vars ~= nil then
			for k, var in pairs(item.vars) do
				vars[k] = var
			end
		end

		v5[item.sourceContentId] = vars
	end

	if next(v5) == nil then
		v5 = nil
	end

	local v6 = { surface = p2, content = v5 }

	if items then
		for k, item in pairs(items) do
			v6[k] = item
		end
	end

	local HttpService = game:GetService("HttpService")
	return HttpService:JSONEncode(v6)
end

return {
	getAuditDataForConsent = getAuditDataForConsent,
	getAuditHeaderValue = getAuditHeaderValue,
	getEncodedAuditHeader = function(p2, p3, p4, p5)
		local auditHeaderValue = getAuditHeaderValue(getAuditDataForConsent(p2, p3), p4, p5)
		return (base64.EncodeUrl(auditHeaderValue))
	end
}
