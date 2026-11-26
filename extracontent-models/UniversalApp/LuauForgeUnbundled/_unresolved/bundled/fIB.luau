local CorePackages = game:GetService("CorePackages")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local module = require("@luauforge/bundled/fIp")

local playButtonReferralSource = require("@luauforge/bundled/fIC").PlayButtonReferralSource

local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
local getDeepValue = module.SocialLibraries.Dictionary.getDeepValue

local Cryo = require(CorePackages.Packages.Cryo)
local module3 = require("@luauforge/bundled/fIe")
require("@luauforge/bundled/fIx")

local fFlagEnableShareLinksInGameDetailEvent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableShareLinksInGameDetailEvent

return function(p2, p3)
	local shareLinksAnalytics = p3.analyticsImpls.shareLinksAnalytics
	local universeId = tostring((getDeepValue(p2, "responseBody.experienceDetailsInviteData") or {}).universeId)
	local joined = Cryo.Dictionary.join(p2, {
		responseBody = Cryo.None,
		type = Cryo.None,
		linkStatus = ExperienceInviteStatus.Valid,
		universeId = universeId
	})

	shareLinksAnalytics.resolveLink(joined)

	if fFlagEnableShareLinksInGameDetailEvent then
		module3(universeId, "GameDetailsShareLink", {})
	else
		module3(universeId, "GameDetailsShareLink")
	end

	local gameDetail = appPage.GameDetail

	return {
		{
			{ name = appPage.Games }
		},
		{
			{ name = appPage.Games },
			{
				name = gameDetail,
				detail = universeId,
				extraProps = {
					mountAsFullView = true,
					mountAnimation = false,
					referralSource = playButtonReferralSource.ExperienceDetailsLink
				}
			}
		}
	}
end
