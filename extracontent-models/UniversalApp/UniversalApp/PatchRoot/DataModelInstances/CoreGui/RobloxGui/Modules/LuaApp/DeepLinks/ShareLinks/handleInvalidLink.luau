local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage

require(CorePackages.Workspace.Packages.NavigationRodux)

local LinkStatus = require(script.Parent.LinkStatus)

require(script.Parent.Types)

return function(t1: {[any]: any}, p1) -- line: 8
	-- upvalues: LinkStatus (copy), AppPage (copy)
	local shareLinksAnalytics = p1.analyticsImpls.shareLinksAnalytics
	local code = t1.code
	local type = t1.type

	shareLinksAnalytics.resolveLink({
		isViaAppsFlyer = t1.isViaAppsFlyer,
		linkId = code,
		linkStatus = LinkStatus.Invalid,
		linkType = type
	})

	return {{
		{
			name = AppPage.Home
		},
		{
			name = AppPage.ShareLinkInvalidModal,
			extraProps = {
				closeModal = function() -- line: 29
					-- upvalues: shareLinksAnalytics (copy), code (copy), LinkStatus (copy), type (copy)
					shareLinksAnalytics.errorDialogButtonClick({
						linkId = code,
						linkStatus = LinkStatus.Invalid,
						linkType = type
					})
				end
			}
		}
	}}
end
