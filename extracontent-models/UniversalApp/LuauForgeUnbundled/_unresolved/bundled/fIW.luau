local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local affiliateJoinLinkResolver = require("@luauforge/bundled/fIX").AffiliateJoinLinkResolver

local playButtonReferralSource = require("@luauforge/bundled/fIC").PlayButtonReferralSource

local module = require("@luauforge/bundled/fIE")

local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
local module3 = require("@luauforge/bundled/fIe")
require("@luauforge/bundled/fIx")
local module4 = require("@luauforge/bundled/fIj")

local fFlagEnableShareLinksInGameDetailEvent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableShareLinksInGameDetailEvent

local v5 = { HOME = "Home", INVALID = "Invalid", PROFILE = "Profile" }

return function(p2, p3, p4)
	local shareLinksAnalytics = p4.analyticsImpls.shareLinksAnalytics
	return affiliateJoinLinkResolver.resolveReferralCode(p4.network, p2):andThen(function(p5)
		local responseBody = p5.responseBody
		local gameDetail = appPage.GameDetail
		local linkId = tostring(responseBody.linkId)
		local universeId

		if not (responseBody.universeId == nil or responseBody.universeId == 0) then
			universeId = tostring(responseBody.universeId)
		end

		local v6 = {
			linkStatus = ExperienceInviteStatus.Valid,
			linkType = module4.ExperienceAffiliate,
			linkId = linkId,
			universeId = universeId,
			isViaAppsFlyer = false
		}

		shareLinksAnalytics.resolveLink(v6)

		if responseBody.universeId == nil or responseBody.universeId == 0 then
			if responseBody.fallbackType == "Profile" then
				return {
					{
						{ name = appPage.Home },
						{
							name = appPage.ProfilePlatform,
							detail = tostring(responseBody.fallbackId)
						}
					}
				}
			end

			return {
				{
					{ name = appPage.Home }
				}
			}
		else
			if fFlagEnableShareLinksInGameDetailEvent then
				module3(universeId, "ExperienceAffiliateShareLink", {
					linkType = module4.ExperienceAffiliate,
					linkId = linkId
				})
			else
				module3(universeId, "ExperienceAffiliateShareLink")
			end

			local v7 = {
				mountAsFullView = true,
				mountAnimation = false,
				referralSource = playButtonReferralSource.ExperienceAffiliateLink
			}

			local joinData = responseBody.joinData

			if joinData then
				v7 = module.mergeExperienceJoinData(v7, joinData)
			end

			return {
				{
					{ name = appPage.Games }
				},
				{
					{ name = appPage.Games },
					{ name = gameDetail, detail = universeId, extraProps = v7 }
				}
			}
		end
	end):catch(function()
		local v6 = {
			linkStatus = ExperienceInviteStatus.Invalid,
			linkId = "",
			linkType = module4.ExperienceAffiliate,
			isViaAppsFlyer = false
		}

		shareLinksAnalytics.resolveLink(v6)

		return {
			{
				{ name = appPage.Home },
				{
					name = appPage.ShareLinkInvalidModal,
					extraProps = {
						closeModal = function()
							shareLinksAnalytics.errorJoinDialogButtonClick(v6)
						end
					}
				}
			}
		}
	end)
end
