local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local useSocialTabsContext = require(SocialTabsPage.Contexts.useSocialTabsContext)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialTabsPageSplitPaneLayout = SharedFlags.FFlagSocialTabsPageSplitPaneLayout

local View = Foundation.View
local Text = Foundation.Text
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function SocialTabsHeader(p)
	local v = useSocialTabsContext()
	local v2 = useNavigation()

	local onActivated = React.useCallback(function()
		v2.goBack()
	end, { v2 })

	local createElement = React.createElement
	local v3 = {
		tag = "row align-y-center gap-small size-full-0 auto-y padding-x-xlarge bg-surface-0",
		LayoutOrder = p.layoutOrder
	}
	local backButton

	if FFlagSocialTabsPageSplitPaneLayout and p.hideBackButton then
		backButton = React.createElement(View, { Size = UDim2.fromOffset(36, 36), LayoutOrder = 1 })
	else
		backButton = React.createElement(IconButton, {
			icon = IconName.ChevronLargeLeft,
			size = IconSize.Medium,
			variant = ButtonVariant.Utility,
			onActivated = onActivated,
			LayoutOrder = 1
		})
	end

	return createElement(View, v3, {
		BackButton = backButton,
		Title = React.createElement(Text, {
			tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
			LayoutOrder = 2,
			Text = v.title or ""
		})
	})
end

return SocialTabsHeader
