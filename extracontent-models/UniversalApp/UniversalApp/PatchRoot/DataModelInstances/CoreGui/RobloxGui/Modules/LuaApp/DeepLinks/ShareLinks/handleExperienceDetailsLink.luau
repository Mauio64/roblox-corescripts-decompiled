local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local dependencies = require(script.Parent.dependencies)
local PlayButtonReferralSource = require(CorePackages.Workspace.Packages.GamePlayButton).PlayButtonReferralSource
local LinkStatus = require(script.Parent.LinkStatus)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local Cryo = require(CorePackages.Packages.Cryo)
local logGameDetailsDeepLinkEvent = require(script.Parent.Parent.logGameDetailsDeepLinkEvent)

require(script.Parent.Types)

local FFlagEnableShareLinksInGameDetailEvent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableShareLinksInGameDetailEvent

return function(p1, p2) -- line: 19
	-- upvalues: getDeepValue (copy), Cryo (copy), LinkStatus (copy), FFlagEnableShareLinksInGameDetailEvent (copy), logGameDetailsDeepLinkEvent (copy), AppPage (copy), PlayButtonReferralSource (copy)
	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics
	local str = tostring((getDeepValue(p1, "responseBody.experienceDetailsInviteData") or {}).universeId)
	local v14 = Cryo.Dictionary.join(p1, {
		responseBody = Cryo.None,
		type = Cryo.None,
		linkStatus = LinkStatus.Valid,
		universeId = str
	})

	shareLinksAnalytics.resolveLink(v14)

	if FFlagEnableShareLinksInGameDetailEvent then
		logGameDetailsDeepLinkEvent(str, "GameDetailsShareLink", {})
	else
		logGameDetailsDeepLinkEvent(str, "GameDetailsShareLink")
	end

	local GameDetail = AppPage.GameDetail

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
				extraProps = {
					mountAsFullView = true,
					mountAnimation = false,
					referralSource = PlayButtonReferralSource.ExperienceDetailsLink
				}
			}
		}
	}
end
