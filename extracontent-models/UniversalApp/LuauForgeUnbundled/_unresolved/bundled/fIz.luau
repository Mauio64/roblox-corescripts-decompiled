local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")

local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
require("@luauforge/bundled/fIx")

return function(data, p2)
	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics

	local code = data.code
	local kind = data.type

	shareLinksAnalytics.resolveLink({
		isViaAppsFlyer = data.isViaAppsFlyer,
		linkId = code,
		linkStatus = ExperienceInviteStatus.Invalid,
		linkType = kind
	})

	return {
		{
			{ name = appPage.Home },
			{
				name = appPage.ShareLinkInvalidModal,
				extraProps = {
					closeModal = function()
						shareLinksAnalytics.errorDialogButtonClick({
							linkId = code,
							linkStatus = ExperienceInviteStatus.Invalid,
							linkType = kind
						})
					end
				}
			}
		}
	}
end
