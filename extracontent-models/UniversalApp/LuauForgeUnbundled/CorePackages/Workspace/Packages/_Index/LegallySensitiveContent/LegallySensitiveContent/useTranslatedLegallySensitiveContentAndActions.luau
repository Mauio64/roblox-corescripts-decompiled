require("@game/CorePackages/Workspace/Packages/_Workspace/LegallySensitiveContent/React")

local updateUserSetting = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Services/userSettingsService").updateUserSetting
local grantOneTimeUserConsent = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Services/usersConsentsService").grantOneTimeUserConsent
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/dependencies").Localization.Hooks.useLocalization
local LegallySensitiveContentConstants = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Constants/LegallySensitiveContentConstants")
local getEncodedAuditHeader = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Utils/AuditUtils").getEncodedAuditHeader
local ConsentName = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Enums/ConsentName")
require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Types/LegallySensitiveContentTypes")

local function useTranslatedLegallySensitiveContentAndActions(p2, p3)
	local v6 = {
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

	local v7 = if p2 == ConsentName.allowMarketingEmailCheckboxAccountUpgrade and LegallySensitiveContentConstants.allowMarketingEmailCheckboxAccountUpgrade.consentSourceContentId ~= "" then LegallySensitiveContentConstants.allowMarketingEmailCheckboxAccountUpgrade.consent else nil
	v6.allowMarketingEmailCheckboxAccountUpgradeConsent = v7
	local v8 = useLocalization(v6)

	local function updateSettingWithAuditing(p4, p5, p6)
		local encodedAuditHeader = getEncodedAuditHeader(p2, v8, p3, p6)
		local success, result = pcall(function()
			updateUserSetting(p4, p5, encodedAuditHeader)
		end)

		if not success then
			warn("Failed to update setting with auditing:", result)
		end
	end

	local function getBase64EncodedAuditHeader(p4)
		return getEncodedAuditHeader(p2, v8, p3, p4)
	end

	local function grantOneTimeUserConsentWithAuditing(p4, p5)
		local encodedAuditHeader = getEncodedAuditHeader(p2, v8, p3, p5)
		local success, result = pcall(function()
			grantOneTimeUserConsent(p2, p4, encodedAuditHeader)
		end)

		if not success then
			warn("Failed to grant one time user consent with auditing:", result)
		end
	end

	return ({
		[ConsentName.phoneNumberDiscoverabilityUpsell] = {
			wordsOfConsent = {
				notNow = v8.phoneNumberDiscoverabilityUpsellNotNow,
				turnOn = v8.phoneNumberDiscoverabilityUpsellTurnOn,
				title = v8.phoneNumberDiscoverabilityUpsellTitle,
				content = v8.phoneNumberDiscoverabilityUpsellContent
			}
		},
		[ConsentName.allowMarketingEmailCheckboxAccountUpgrade] = {
			wordsOfConsent = {
				consent = v8.allowMarketingEmailCheckboxAccountUpgradeConsent
			}
		},
		[ConsentName.allowMarketingEmailAutoOptInAccountUpgrade] = { wordsOfConsent = {} }
	})[p2], {
		getBase64EncodedAuditHeader = getBase64EncodedAuditHeader,
		updateSettingWithAuditing = updateSettingWithAuditing,
		grantOneTimeUserConsentWithAuditing = grantOneTimeUserConsentWithAuditing
	}
end

return useTranslatedLegallySensitiveContentAndActions
