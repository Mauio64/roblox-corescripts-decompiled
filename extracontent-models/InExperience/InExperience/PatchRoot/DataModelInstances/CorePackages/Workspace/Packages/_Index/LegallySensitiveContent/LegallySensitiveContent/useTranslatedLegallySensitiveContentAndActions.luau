local LegallySensitiveContent = script:FindFirstAncestor("LegallySensitiveContent")
local parent = LegallySensitiveContent.Parent

require(parent.React)

local userSettingsService = require(LegallySensitiveContent.Services.userSettingsService)
local updateUserSetting = userSettingsService.updateUserSetting
local usersConsentsService = require(LegallySensitiveContent.Services.usersConsentsService)
local grantOneTimeUserConsent = usersConsentsService.grantOneTimeUserConsent
local dependencies = require(LegallySensitiveContent.dependencies)
local useLocalization = dependencies.Localization.Hooks.useLocalization
local LegallySensitiveContentConstants = require(LegallySensitiveContent.Constants.LegallySensitiveContentConstants)
local AuditUtils = require(LegallySensitiveContent.Utils.AuditUtils)
local getEncodedAuditHeader = AuditUtils.getEncodedAuditHeader
local ConsentName = require(LegallySensitiveContent.Enums.ConsentName)
require(LegallySensitiveContent.Types.LegallySensitiveContentTypes)

local function useTranslatedLegallySensitiveContentAndActions(p, p2: string)
	local v = {
		phoneNumberDiscoverabilityUpsellNotNow = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.notNow,
		phoneNumberDiscoverabilityUpsellTurnOn = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.turnOn,
		phoneNumberDiscoverabilityUpsellTitle = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.title,
		phoneNumberDiscoverabilityUpsellContent = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.content,
		photoToAvatarTitle = LegallySensitiveContentConstants.photoToAvatar.title,
		photoToAvatarBodyText = LegallySensitiveContentConstants.photoToAvatar.bodyText,
		photoToAvatarPrivacyLinkText = LegallySensitiveContentConstants.photoToAvatar.privacyLinkText,
		photoToAvatarAgreeButton = LegallySensitiveContentConstants.photoToAvatar.agreeButton,
		photoToAvatarCancelButton = LegallySensitiveContentConstants.photoToAvatar.cancelButton,
		allowMarketingEmailCheckboxAccountUpgradeConsent = 0
	}
	local allowMarketingEmailCheckboxAccountUpgradeConsent

	if
		p == ConsentName.allowMarketingEmailCheckboxAccountUpgrade
		and LegallySensitiveContentConstants.allowMarketingEmailCheckboxAccountUpgrade.consentSourceContentId ~= ""
	then
		allowMarketingEmailCheckboxAccountUpgradeConsent = LegallySensitiveContentConstants.allowMarketingEmailCheckboxAccountUpgrade.consent
	end

	v.allowMarketingEmailCheckboxAccountUpgradeConsent = allowMarketingEmailCheckboxAccountUpgradeConsent
	local v2 = useLocalization(v)

	local function updateSettingWithAuditing(p3: string, p4, p5)
		local encodedAuditHeader = getEncodedAuditHeader(p, v2, p2, p5)
		local success, result = pcall(function()
			updateUserSetting(p3, p4, encodedAuditHeader)
		end)

		if not success then
			warn("Failed to update setting with auditing:", result)
		end
	end

	local function getBase64EncodedAuditHeader(p3)
		return getEncodedAuditHeader(p, v2, p2, p3)
	end

	local function grantOneTimeUserConsentWithAuditing(p3: number?, p4)
		local encodedAuditHeader = getEncodedAuditHeader(p, v2, p2, p4)
		local success, result = pcall(function()
			grantOneTimeUserConsent(p, p3, encodedAuditHeader)
		end)

		if not success then
			warn("Failed to grant one time user consent with auditing:", result)
		end
	end

	return ({
		[ConsentName.phoneNumberDiscoverabilityUpsell] = {
			wordsOfConsent = {
				notNow = v2.phoneNumberDiscoverabilityUpsellNotNow,
				turnOn = v2.phoneNumberDiscoverabilityUpsellTurnOn,
				title = v2.phoneNumberDiscoverabilityUpsellTitle,
				content = v2.phoneNumberDiscoverabilityUpsellContent
			}
		},
		[ConsentName.allowMarketingEmailCheckboxAccountUpgrade] = {
			wordsOfConsent = { consent = v2.allowMarketingEmailCheckboxAccountUpgradeConsent }
		},
		[ConsentName.allowMarketingEmailAutoOptInAccountUpgrade] = { wordsOfConsent = {} }
	})[p], {
		getBase64EncodedAuditHeader = getBase64EncodedAuditHeader,
		updateSettingWithAuditing = updateSettingWithAuditing,
		grantOneTimeUserConsentWithAuditing = grantOneTimeUserConsentWithAuditing
	}
end

return useTranslatedLegallySensitiveContentAndActions
