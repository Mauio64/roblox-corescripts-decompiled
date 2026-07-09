local LegallySensitiveContent = script:FindFirstAncestor("LegallySensitiveContent")
local LegallySensitiveContentParent = LegallySensitiveContent.Parent

require(LegallySensitiveContentParent.React)

local updateUserSetting = require(LegallySensitiveContent.Services.userSettingsService).updateUserSetting
local grantOneTimeUserConsent = require(LegallySensitiveContent.Services.usersConsentsService).grantOneTimeUserConsent
local useLocalization = require(LegallySensitiveContent.dependencies).Localization.Hooks.useLocalization
local LegallySensitiveContentConstants = require(LegallySensitiveContent.Constants.LegallySensitiveContentConstants)
local getEncodedAuditHeader = require(LegallySensitiveContent.Utils.AuditUtils).getEncodedAuditHeader
local ConsentName = require(LegallySensitiveContent.Enums.ConsentName)

require(LegallySensitiveContent.Types.LegallySensitiveContentTypes)

local function useTranslatedLegallySensitiveContentAndActions(p1, s1: string) -- line: 31
	-- upvalues: useLocalization (copy), LegallySensitiveContentConstants (copy), ConsentName (copy), getEncodedAuditHeader (copy), updateUserSetting (copy), grantOneTimeUserConsent (copy)
	local v12 = useLocalization({
		phoneNumberDiscoverabilityUpsellNotNow = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.notNow,
		phoneNumberDiscoverabilityUpsellTurnOn = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.turnOn,
		phoneNumberDiscoverabilityUpsellTitle = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.title,
		phoneNumberDiscoverabilityUpsellContent = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.content,
		photoToAvatarTitle = LegallySensitiveContentConstants.photoToAvatar.title,
		photoToAvatarBodyText = LegallySensitiveContentConstants.photoToAvatar.bodyText,
		photoToAvatarPrivacyLinkText = LegallySensitiveContentConstants.photoToAvatar.privacyLinkText,
		photoToAvatarAgreeButton = LegallySensitiveContentConstants.photoToAvatar.agreeButton,
		photoToAvatarCancelButton = LegallySensitiveContentConstants.photoToAvatar.cancelButton
	})

	return ({
		[ConsentName.phoneNumberDiscoverabilityUpsell] = {
			wordsOfConsent = {
				notNow = v12.phoneNumberDiscoverabilityUpsellNotNow,
				turnOn = v12.phoneNumberDiscoverabilityUpsellTurnOn,
				title = v12.phoneNumberDiscoverabilityUpsellTitle,
				content = v12.phoneNumberDiscoverabilityUpsellContent
			}
		}
	})[p1], {
		getBase64EncodedAuditHeader = function(t1: {[any]: any}?) -- line: 101
			-- upvalues: getEncodedAuditHeader (copy), p1 (copy), v12 (copy), s1 (copy)
			return getEncodedAuditHeader(p1, v12, s1, t1)
		end,
		updateSettingWithAuditing = function(s2: string, p2, t2: {[any]: any}?) -- line: 85
			-- upvalues: getEncodedAuditHeader (copy), p1 (copy), v12 (copy), s1 (copy), updateUserSetting (copy)
			local v16 = getEncodedAuditHeader(p1, v12, s1, t2)
			local ok, result = pcall(function() -- line: 92
				-- upvalues: updateUserSetting (copy), s2 (copy), p2 (copy), v16 (copy)
				updateUserSetting(s2, p2, v16)
			end)

			if not ok then
				warn("Failed to update setting with auditing:", result)
			end
		end,
		grantOneTimeUserConsentWithAuditing = function(n1: number?, t3: {[any]: any}?) -- line: 105
			-- upvalues: getEncodedAuditHeader (copy), p1 (copy), v12 (copy), s1 (copy), grantOneTimeUserConsent (copy)
			local v22 = getEncodedAuditHeader(p1, v12, s1, t3)
			local ok, result = pcall(function() -- line: 111
				-- upvalues: grantOneTimeUserConsent (copy), p1 (copy), n1 (copy), v22 (copy)
				grantOneTimeUserConsent(p1, n1, v22)
			end)

			if not ok then
				warn("Failed to grant one time user consent with auditing:", result)
			end
		end
	}
end

return useTranslatedLegallySensitiveContentAndActions
