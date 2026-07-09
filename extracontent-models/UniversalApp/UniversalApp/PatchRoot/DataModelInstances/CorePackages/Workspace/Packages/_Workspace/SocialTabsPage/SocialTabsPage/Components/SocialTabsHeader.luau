local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local Foundation = require(SocialTabsPageParent.Foundation)
local useNavigation = require(SocialTabsPageParent.Navigation).useNavigation
local useSocialTabsContext = require(SocialTabsPage.Contexts.useSocialTabsContext)
local View = Foundation.View
local FoundationText = Foundation.Text
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function SocialTabsHeader(t1: {[any]: any}) -- line: 20
	-- upvalues: useSocialTabsContext (copy), useNavigation (copy), React (copy), View (copy), IconButton (copy), IconName (copy), IconSize (copy), ButtonVariant (copy), FoundationText (copy)
	local v15 = useSocialTabsContext()
	local v16 = useNavigation()
	local v17 = React.useCallback(function() -- line: 24
		-- upvalues: v16 (copy)
		v16.goBack()
	end, { v16 })

	return React.createElement(View, {
		tag = "row align-y-center gap-small size-full-0 auto-y padding-x-xlarge bg-surface-0",
		LayoutOrder = t1.layoutOrder
	}, {
		BackButton = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = IconName.ChevronLargeLeft,
			size = IconSize.Medium,
			variant = ButtonVariant.Utility,
			onActivated = v17
		}),
		Title = React.createElement(FoundationText, {
			tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
			LayoutOrder = 2,
			Text = v15.title or ""
		})
	})
end

return SocialTabsHeader
