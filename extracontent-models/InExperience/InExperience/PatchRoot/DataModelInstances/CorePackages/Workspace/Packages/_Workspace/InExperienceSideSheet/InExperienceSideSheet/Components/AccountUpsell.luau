local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

require(parent.Chrome)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization

local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)
local closePeoplePageOpenedWithSideSheet = require(InExperienceSideSheet.Utils.closePeoplePageOpenedWithSideSheet)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local Flags = require(InExperienceSideSheet.Flags)
local FFlagSideSheetOpenPeoplePage = Flags.FFlagSideSheetOpenPeoplePage

local function AccountUpsell(p)
	local v = useTokens()
	local v2 = useLocalization({
		title = "CoreScripts.InGameMenu.UnlockMore.Title",
		description = "CoreScripts.InGameMenu.UnlockMore.Description"
	})

	local onActivated = React.useCallback(function()
		p.onActivated()

		if FFlagSideSheetOpenPeoplePage then
			closePeoplePageOpenedWithSideSheet()
		end

		toggleSideSheet(false)
		SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.AccountUpsell)
	end, { p.onActivated })

	return React.createElement(
		View,
		{
			LayoutOrder = p.layoutOrder,
			tag = "size-full-0 auto-y padding-bottom-medium padding-top-small",
			testId = "account-upsell-container"
		},
		{
			Card = React.createElement(
				View,
				{
					onActivated = onActivated,
					tag = "row align-y-center size-full-0 auto-y padding-medium radius-medium bg-shift-200",
					testId = "account-upsell-card"
				},
				{
					LeadingAccessory = React.createElement(
						View,
						{
							LayoutOrder = 1,
							tag = "row align-x-center align-y-center size-1200-1200 radius-medium clip bg-system-emphasis"
						},
						{
							Logo = React.createElement(Icon, {
								name = IconName.Tilt,
								size = v.Size.Size_1000,
								style = v.DarkMode.Content.Emphasis,
								testId = "account-upsell-logo",
								variant = IconVariant.Filled
							})
						}
					),
					Content = React.createElement(
						View,
						{ LayoutOrder = 2, tag = "col fill auto-y padding-left-medium" },
						{
							Title = React.createElement(Text, {
								LayoutOrder = 1,
								Text = v2.title,
								tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis"
							}),
							Description = React.createElement(Text, {
								LayoutOrder = 2,
								Text = v2.description,
								tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-emphasis"
							})
						}
					)
				}
			)
		}
	)
end

return React.memo(AccountUpsell)
