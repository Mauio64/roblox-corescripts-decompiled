local parent = script.Parent.Parent
local CryptoUtils = require(script.Parent.CryptoUtils)
local LegallySensitiveContentConstants = require(parent.Constants.LegallySensitiveContentConstants)
local dependencies = require(parent.dependencies)
local base64 = dependencies.Base64
local ConsentName = require(parent.Enums.ConsentName)

require(parent.Types.LegallySensitiveContentTypes)

local function getAuditDataForConsent(p, data)
	return ({
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
	})[p] or {}
end

local function getAuditHeaderValue(auditDataForConsent, surface: string, items)
	local content = {}

	for _, item in ipairs(auditDataForConsent) do
		local vars = {
			hash = CryptoUtils.hashStringWithFnv1a32(item.consentStringTemplate)
		}

		if item.vars ~= nil then
			for k, var in pairs(item.vars) do
				vars[k] = var
			end
		end

		content[item.sourceContentId] = vars
	end

	if next(content) == nil then
		content = nil
	end

	local v = { surface = surface, content = content }

	if items then
		for k, item in pairs(items) do
			v[k] = item
		end
	end

	local HttpService = game:GetService("HttpService")
	return HttpService:JSONEncode(v)
end

return {
	getAuditDataForConsent = getAuditDataForConsent,
	getAuditHeaderValue = getAuditHeaderValue,
	getEncodedAuditHeader = function(p, p2, surface: string, p3)
		local auditHeaderValue = getAuditHeaderValue(getAuditDataForConsent(p, p2), surface, p3)
		return (base64.EncodeUrl(auditHeaderValue))
	end
}
