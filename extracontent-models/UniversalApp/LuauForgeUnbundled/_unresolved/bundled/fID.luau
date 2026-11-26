local CorePackages = game:GetService("CorePackages")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local module = require("@luauforge/bundled/fIp")

local playButtonReferralSource = require("@luauforge/bundled/fIC").PlayButtonReferralSource

local module2 = require("@luauforge/bundled/fIE")

local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
local getDeepValue = module.SocialLibraries.Dictionary.getDeepValue
local Cryo = require(CorePackages.Packages.Cryo)
local module4 = require("@luauforge/bundled/fIe")
require("@luauforge/bundled/fIx")
local module5 = require("@luauforge/bundled/fIF")

local fFlagEnableShareLinksInGameDetailEvent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableShareLinksInGameDetailEvent

function LUAUFORGE_MODULE_GLOBALS_fID_shouldResolveToProfileFallbackType(p2): boolean
	local v5 = module5.fromRawValue(p2)

	return v5 ~= nil and v5 == module5.EXPERIENCE_AFFILIATE_DEEP_LINK_FALLBACK_TYPE_PROFILE
end

return function(p2, p3)
	local shareLinksAnalytics = p3.analyticsImpls.shareLinksAnalytics
	local v5 = getDeepValue(p2, "responseBody.experienceAffiliateData") or {}

	if v5.universeId == nil or v5.universeId == 0 then
		local joined = Cryo.Dictionary.join(p2, {
			responseBody = Cryo.None,
			type = Cryo.None,
			linkStatus = ExperienceInviteStatus.Valid
		})

		shareLinksAnalytics.resolveLink(joined)

		if LUAUFORGE_MODULE_GLOBALS_fID_shouldResolveToProfileFallbackType(v5.fallbackType) then
			return {
				{
					{ name = appPage.Home },
					{ name = appPage.ProfilePlatform, detail = tostring(v5.fallbackId) }
				}
			}
		end

		return {
			{
				{ name = appPage.Home }
			}
		}
	else
		local gameDetail = appPage.GameDetail
		local universeId = tostring(v5.universeId)
		local joined = Cryo.Dictionary.join(p2, {
			responseBody = Cryo.None,
			type = Cryo.None,
			linkStatus = ExperienceInviteStatus.Valid,
			universeId = universeId
		})

		shareLinksAnalytics.resolveLink(joined)

		if fFlagEnableShareLinksInGameDetailEvent then
			module4(universeId, "ExperienceAffiliateShareLink", {
				linkType = p2.linkType,
				linkId = p2.linkId
			})
		else
			module4(universeId, "ExperienceAffiliateShareLink")
		end

		local v6 = {
			mountAsFullView = true,
			mountAnimation = false,
			referralSource = playButtonReferralSource.ExperienceAffiliateLink
		}

		local joinData = v5.joinData

		if joinData then
			v6 = module2.mergeExperienceJoinData(v6, joinData)
		end

		return {
			{
				{ name = appPage.Games }
			},
			{
				{ name = appPage.Games },
				{ name = gameDetail, detail = universeId, extraProps = v6 }
			}
		}
	end
end
