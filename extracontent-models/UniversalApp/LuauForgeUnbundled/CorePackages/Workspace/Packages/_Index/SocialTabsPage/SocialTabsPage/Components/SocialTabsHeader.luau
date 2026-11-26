local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Foundation")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Navigation").useNavigation
local useSocialTabsContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Contexts/useSocialTabsContext")
local fFlagSocialTabsPageSplitPaneLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SharedFlags").FFlagSocialTabsPageSplitPaneLayout

local view = Foundation.View
local text = Foundation.Text
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local buttonVariant = Foundation.Enums.ButtonVariant

local function SocialTabsHeader(p2)
	local v5 = useSocialTabsContext()
	local v6 = useNavigation()

	local v7 = React.useCallback(function()
		v6.goBack()
	end, { v6 })

	local createElement = React.createElement
	local v9 = {
		tag = "row align-y-center gap-small size-full-0 auto-y padding-x-xlarge bg-surface-0",
		LayoutOrder = p2.layoutOrder
	}

	local v11 = if fFlagSocialTabsPageSplitPaneLayout and p2.hideBackButton then React.createElement(view, {
		Size = UDim2.fromOffset(36, 36),
		LayoutOrder = 1
	}) else React.createElement(iconButton, {
		icon = iconName.ChevronLargeLeft,
		size = iconSize.Medium,
		variant = buttonVariant.Utility,
		onActivated = v7,
		LayoutOrder = 1
	})
	return createElement(view, v9, {
		BackButton = v11,
		Title = React.createElement(text, {
			tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
			LayoutOrder = 2,
			Text = v5.title or ""
		})
	})
end

return SocialTabsHeader
