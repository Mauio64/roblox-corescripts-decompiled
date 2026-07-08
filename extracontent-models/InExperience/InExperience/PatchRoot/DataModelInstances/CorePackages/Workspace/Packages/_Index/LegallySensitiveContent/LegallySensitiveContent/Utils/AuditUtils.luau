local ParentParent = script.Parent.Parent
local CryptoUtils = require(script.Parent.CryptoUtils)
local LegallySensitiveContentConstants = require(ParentParent.Constants.LegallySensitiveContentConstants)
local Base64 = require(ParentParent.dependencies).Base64
local ConsentName = require(ParentParent.Enums.ConsentName)

require(ParentParent.Types.LegallySensitiveContentTypes)

local function getAuditDataForConsent(p1, t1: {[any]: any}) -- line: 18
	-- upvalues: ConsentName (copy), LegallySensitiveContentConstants (copy)
	local v10 = ({
		[ConsentName.phoneNumberDiscoverabilityUpsell] = {
			{
				consentStringTemplate = t1.phoneNumberDiscoverabilityUpsellNotNow,
				sourceContentId = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.notNowSourceContentId
			},
			{
				consentStringTemplate = t1.phoneNumberDiscoverabilityUpsellTurnOn,
				sourceContentId = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.turnOnSourceContentId
			},
			{
				consentStringTemplate = t1.phoneNumberDiscoverabilityUpsellTitle,
				sourceContentId = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.titleSourceContentId
			},
			{
				consentStringTemplate = t1.phoneNumberDiscoverabilityUpsellContent,
				sourceContentId = LegallySensitiveContentConstants.phoneNumberDiscoverabilityUpsell.contentSourceContentId
			}
		},
		[ConsentName.PhotoToAvatar] = {
			{
				consentStringTemplate = t1.photoToAvatarTitle,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.titleSourceContentId
			},
			{
				consentStringTemplate = t1.photoToAvatarBodyText,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.bodyTextSourceContentId
			},
			{
				consentStringTemplate = t1.photoToAvatarPrivacyLinkText,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.privacyLinkTextSourceContentId
			},
			{
				consentStringTemplate = t1.photoToAvatarAgreeButton,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.agreeButtonSourceContentId
			},
			{
				consentStringTemplate = t1.photoToAvatarCancelButton,
				sourceContentId = LegallySensitiveContentConstants.photoToAvatar.cancelButtonSourceContentId
			}
		}
	})[p1]

	if v10 then
		return v10
	end

	return {}
end
local function getAuditHeaderValue(t2: {[any]: any}, s1: string, t3: {[any]: any}?) -- line: 98
	-- upvalues: CryptoUtils (copy)
	local t4 = {}

	for _, v in ipairs(t2) do
		local t5 = {
			hash = CryptoUtils.hashStringWithFnv1a32(v.consentStringTemplate)
		}

		if v.vars ~= nil then
			for k, v2 in pairs(v.vars) do
				t5[k] = v2
			end
		end

		t4[v.sourceContentId] = t5
	end

	local t6 = {
		surface = s1,
		content = t4
	}

	if t3 then
		for k, v in pairs(t3) do
			t6[k] = v
		end
	end

	return game:GetService("HttpService"):JSONEncode(t6)
end

return {
	getAuditDataForConsent = getAuditDataForConsent,
	getAuditHeaderValue = getAuditHeaderValue,
	getEncodedAuditHeader = function(p2, t7: {[any]: any}, s2: string, t8: {[any]: any}?) -- line: 138
		-- upvalues: getAuditDataForConsent (copy), getAuditHeaderValue (copy), Base64 (copy)
		local v27 = getAuditDataForConsent(p2, t7)
		local v28 = getAuditHeaderValue(v27, s2, t8)

		return (Base64.EncodeUrl(v28))
	end
}
