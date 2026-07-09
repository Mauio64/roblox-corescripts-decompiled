local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local AffiliateJoinLinkResolver = require(CorePackages.Workspace.Packages.AffiliateLinks).AffiliateJoinLinkResolver
local PlayButtonReferralSource = require(CorePackages.Workspace.Packages.GamePlayButton).PlayButtonReferralSource
local ExperienceJoinDataHelper = require(script.Parent.Parent.Utils.ExperienceJoinDataHelper)
local LinkStatus = require(script.Parent.LinkStatus)
local logGameDetailsDeepLinkEvent = require(script.Parent.Parent.logGameDetailsDeepLinkEvent)

require(script.Parent.Types)

local ShareLinkTypes = require(script.Parent.ShareLinkTypes)
local FFlagEnableShareLinksInGameDetailEvent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableShareLinksInGameDetailEvent
local _ = {
	HOME = "Home",
	INVALID = "Invalid",
	PROFILE = "Profile"
}

return function(s1: string, _: {[any]: any}, p1) -- line: 26
	-- upvalues: AffiliateJoinLinkResolver (copy), AppPage (copy), LinkStatus (copy), ShareLinkTypes (copy), FFlagEnableShareLinksInGameDetailEvent (copy), logGameDetailsDeepLinkEvent (copy), PlayButtonReferralSource (copy), ExperienceJoinDataHelper (copy)
	local shareLinksAnalytics = p1.analyticsImpls.shareLinksAnalytics

	return AffiliateJoinLinkResolver.resolveReferralCode(p1.network, s1):andThen(function(p2) -- line: 29
		-- upvalues: AppPage (copy), LinkStatus (copy), ShareLinkTypes (copy), shareLinksAnalytics (copy), FFlagEnableShareLinksInGameDetailEvent (copy), logGameDetailsDeepLinkEvent (copy), PlayButtonReferralSource (copy), ExperienceJoinDataHelper (copy)
		local str = nil
		local responseBody = p2.responseBody
		local GameDetail = AppPage.GameDetail
		local str2 = tostring(responseBody.linkId)

		if responseBody.universeId ~= nil and responseBody.universeId ~= 0 then
			str = tostring(responseBody.universeId)
		end

		local t2 = {
			isViaAppsFlyer = false,
			linkStatus = LinkStatus.Valid,
			linkType = ShareLinkTypes.ExperienceAffiliate,
			linkId = str2,
			universeId = str
		}

		shareLinksAnalytics.resolveLink(t2)

		if responseBody.universeId ~= nil and responseBody.universeId ~= 0 then
			if FFlagEnableShareLinksInGameDetailEvent then
				logGameDetailsDeepLinkEvent(str, "ExperienceAffiliateShareLink", {
					linkType = ShareLinkTypes.ExperienceAffiliate,
					linkId = str2
				})
			else
				logGameDetailsDeepLinkEvent(str, "ExperienceAffiliateShareLink")
			end

			local t3 = {
				mountAsFullView = true,
				mountAnimation = false,
				referralSource = PlayButtonReferralSource.ExperienceAffiliateLink
			}
			local joinData = responseBody.joinData
			local v23 = if not joinData then t3 else ExperienceJoinDataHelper.mergeExperienceJoinData(t3, joinData)

			return {
				{{
					name = AppPage.Games
				}},
				{
					{
						name = AppPage.Games
					},
					{
						name = GameDetail,
						detail = str,
						extraProps = v23
					}
				}
			}
		end

		if responseBody.fallbackType == "Profile" then
			return {{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.ProfilePlatform,
					detail = tostring(responseBody.fallbackId)
				}
			}}
		end

		return {{{
			name = AppPage.Home
		}}}
	end):catch(function() -- line: 103
		-- upvalues: LinkStatus (copy), ShareLinkTypes (copy), shareLinksAnalytics (copy), AppPage (copy)
		local t4 = {
			linkId = "",
			isViaAppsFlyer = false,
			linkStatus = LinkStatus.Invalid,
			linkType = ShareLinkTypes.ExperienceAffiliate
		}

		shareLinksAnalytics.resolveLink(t4)

		return {{
			{
				name = AppPage.Home
			},
			{
				name = AppPage.ShareLinkInvalidModal,
				extraProps = {
					closeModal = function() -- line: 118
						-- upvalues: shareLinksAnalytics (copy), t4 (copy)
						shareLinksAnalytics.errorJoinDialogButtonClick(t4)
					end
				}
			}
		}}
	end)
end
