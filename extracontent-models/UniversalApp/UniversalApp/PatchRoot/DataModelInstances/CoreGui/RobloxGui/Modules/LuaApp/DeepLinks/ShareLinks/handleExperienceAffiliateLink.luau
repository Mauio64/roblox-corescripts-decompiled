local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local dependencies = require(script.Parent.dependencies)
local PlayButtonReferralSource = require(CorePackages.Workspace.Packages.GamePlayButton).PlayButtonReferralSource
local ExperienceJoinDataHelper = require(script.Parent.Parent.Utils.ExperienceJoinDataHelper)
local LinkStatus = require(script.Parent.LinkStatus)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local Cryo = require(CorePackages.Packages.Cryo)
local logGameDetailsDeepLinkEvent = require(script.Parent.Parent.logGameDetailsDeepLinkEvent)

require(script.Parent.Types)

local ExperienceAffiliateDeepLinkFallbackType = require(script.Parent.Enums.ExperienceAffiliateDeepLinkFallbackType)
local FFlagEnableShareLinksInGameDetailEvent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableShareLinksInGameDetailEvent

function shouldResolveToProfileFallbackType(n1: number) -- line: 26
	-- upvalues: ExperienceAffiliateDeepLinkFallbackType (copy)
	local v13 = ExperienceAffiliateDeepLinkFallbackType.fromRawValue(n1)

	return v13 ~= nil and v13 == ExperienceAffiliateDeepLinkFallbackType.EXPERIENCE_AFFILIATE_DEEP_LINK_FALLBACK_TYPE_PROFILE
end

return function(p1, p2) -- line: 34
	-- upvalues: getDeepValue (copy), AppPage (copy), Cryo (copy), LinkStatus (copy), FFlagEnableShareLinksInGameDetailEvent (copy), logGameDetailsDeepLinkEvent (copy), PlayButtonReferralSource (copy), ExperienceJoinDataHelper (copy)
	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics
	local v17 = getDeepValue(p1, "responseBody.experienceAffiliateData") or {}

	if v17.universeId ~= nil and v17.universeId ~= 0 then
		local GameDetail = AppPage.GameDetail
		local str = tostring(v17.universeId)
		local v20 = Cryo.Dictionary.join(p1, {
			responseBody = Cryo.None,
			type = Cryo.None,
			linkStatus = LinkStatus.Valid,
			universeId = str
		})

		shareLinksAnalytics.resolveLink(v20)

		if FFlagEnableShareLinksInGameDetailEvent then
			logGameDetailsDeepLinkEvent(str, "ExperienceAffiliateShareLink", {
				linkType = p1.linkType,
				linkId = p1.linkId
			})
		else
			logGameDetailsDeepLinkEvent(str, "ExperienceAffiliateShareLink")
		end

		local t1 = {
			mountAsFullView = true,
			mountAnimation = false,
			referralSource = PlayButtonReferralSource.ExperienceAffiliateLink
		}
		local joinData = v17.joinData
		local v23 = if not joinData then t1 else ExperienceJoinDataHelper.mergeExperienceJoinData(t1, joinData)

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

	local v24 = Cryo.Dictionary.join(p1, {
		responseBody = Cryo.None,
		type = Cryo.None,
		linkStatus = LinkStatus.Valid
	})

	shareLinksAnalytics.resolveLink(v24)

	if shouldResolveToProfileFallbackType(v17.fallbackType) then
		return {{
			{
				name = AppPage.Home
			},
			{
				name = AppPage.ProfilePlatform,
				detail = tostring(v17.fallbackId)
			}
		}}
	end

	return {{{
		name = AppPage.Home
	}}}
end
