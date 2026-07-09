local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local useLocalization = require(InExperienceShopParent.Localization).Hooks.useLocalization
local shopOverflowConstants = require(InExperienceShop.Components.Shared.shopOverflowConstants)
local View = Foundation.View
local FoundationText = Foundation.Text
local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local OVERFLOW_ICON = shopOverflowConstants.OVERFLOW_ICON
local REPORT_ICON = shopOverflowConstants.REPORT_ICON
local REPORT_MENU_ITEM_ID = shopOverflowConstants.REPORT_MENU_ITEM_ID
local t1 = {
	title = "Feature.Avatar.Action.Shop",
	report = "Feature.Catalog.Action.Report"
}

local function TopBar(t2: {[any]: any}) -- line: 39
	-- upvalues: useLocalization (copy), t1 (copy), REPORT_MENU_ITEM_ID (copy), REPORT_ICON (copy), React (copy), Menu (copy), InputSize (copy), PopoverSide (copy), PopoverAlign (copy), IconButton (copy), OVERFLOW_ICON (copy), ButtonVariant (copy), View (copy), IconName (copy), FoundationText (copy)
	local v22 = useLocalization(t1)
	local t3 = {}

	if t2.isReportingEnabled then
		table.insert(t3, {
			id = REPORT_MENU_ITEM_ID,
			icon = REPORT_ICON,
			text = v22.report
		})
	end

	local v24 = if not t2.isReportingEnabled then nil else React.createElement(Menu, {
		LayoutOrder = 1,
		testId = "TopBar_OverflowMenu",
		isOpen = t2.isOverflowMenuOpen,
		items = t3,
		size = InputSize.Medium,
		side = PopoverSide.Top,
		align = PopoverAlign.End,
		onPressedOutside = t2.onOverflowMenuClosed,
		onActivated = t2.onMenuItemActivated
	}, {
		Trigger = React.createElement(IconButton, {
			isCircular = false,
			testId = "TopBar_OverflowButton",
			icon = OVERFLOW_ICON,
			size = InputSize.Medium,
			variant = ButtonVariant.Utility,
			onActivated = t2.onOverflowActivated
		})
	})

	return React.createElement(View, {
		tag = "row flex-between align-y-center size-full-1200 padding-x-xlarge radius-medium bg-surface-0"
	}, {
		Leading = React.createElement(View, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 1
		}, {
			CloseButtonContainer = React.createElement(View, {
				tag = "auto-xy padding-top-xxsmall",
				LayoutOrder = 1
			}, {
				CloseButton = React.createElement(IconButton, {
					isCircular = false,
					icon = IconName.X,
					size = InputSize.Medium,
					variant = ButtonVariant.Utility,
					onActivated = t2.onClose
				})
			}),
			Title = React.createElement(FoundationText, {
				tag = "size-0-1000 auto-x text-heading-small text-align-y-center content-emphasis",
				LayoutOrder = 2,
				Text = v22.title
			})
		}),
		Trailing = React.createElement(View, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 2
		}, {
			Overflow = v24,
			SearchButton = React.createElement(IconButton, {
				isCircular = false,
				LayoutOrder = 2,
				testId = "SearchButton",
				icon = IconName.MagnifyingGlass,
				size = InputSize.Medium,
				variant = ButtonVariant.Utility,
				onActivated = t2.onSearchOpen
			})
		})
	})
end

return TopBar
