local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local shopOverflowConstants = require(InExperienceShop.Components.Shared.shopOverflowConstants)

local View = Foundation.View
local Text = Foundation.Text
local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local Chip = Foundation.Chip
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant

local OVERFLOW_ICON = shopOverflowConstants.OVERFLOW_ICON
local REPORT_ICON = shopOverflowConstants.REPORT_ICON
local REPORT_MENU_ITEM_ID = shopOverflowConstants.REPORT_MENU_ITEM_ID

local v = { title = "Feature.Avatar.Action.Shop", report = "Feature.Catalog.Action.Report" }

local function TopBar(props)
	local v2 = useLocalization(v)

	local items = {}

	if props.isReportingEnabled then
		table.insert(items, { id = REPORT_MENU_ITEM_ID, icon = REPORT_ICON, text = v2.report })
	end

	local overflow

	if props.isReportingEnabled then
		overflow = React.createElement(Menu, {
			isOpen = props.isOverflowMenuOpen,
			items = items,
			size = InputSize.Medium,
			side = PopoverSide.Top,
			align = PopoverAlign.End,
			onPressedOutside = props.onOverflowMenuClosed,
			onActivated = props.onMenuItemActivated,
			LayoutOrder = 2,
			testId = "TopBar_OverflowMenu"
		}, {
			Trigger = React.createElement(IconButton, {
				icon = OVERFLOW_ICON,
				isCircular = false,
				size = InputSize.Medium,
				variant = ButtonVariant.Utility,
				onActivated = props.onOverflowActivated,
				testId = "TopBar_OverflowButton"
			})
		})
	end

	local createElement = React.createElement

	local v3 = {
		Leading = React.createElement(View, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 1
		}, {
			CloseButtonContainer = React.createElement(View, {
				tag = "auto-xy padding-top-xxsmall",
				LayoutOrder = 1
			}, {
				CloseButton = React.createElement(IconButton, {
					icon = IconName.X,
					isCircular = false,
					size = InputSize.Medium,
					variant = ButtonVariant.Utility,
					onActivated = props.onClose
				})
			}),
			Title = React.createElement(Text, {
				tag = "size-0-1000 auto-x text-heading-small text-align-y-center content-emphasis",
				Text = v2.title,
				LayoutOrder = 2
			})
		}),
		Trailing = 0
	}

	local createElement2 = React.createElement
	local offerChip

	if props.showOfferChip then
		offerChip = React.createElement(Chip, {
			text = props.offerChipText,
			leading = {
				iconName = props.offerChipIcon and IconName[props.offerChipIcon] or IconName.Tag,
				iconVariant = IconVariant.Filled
			},
			size = ChipSize.Small,
			variant = ChipVariant.Standard,
			onActivated = props.onOfferChipActivated,
			LayoutOrder = 1,
			testId = "OfferChip"
		})
	end

	v3.Trailing = createElement2(View, {
		tag = "row align-y-center gap-small auto-xy",
		LayoutOrder = 3
	}, {
		OfferChip = offerChip,
		Overflow = overflow,
		SearchButton = React.createElement(IconButton, {
			icon = IconName.MagnifyingGlass,
			isCircular = false,
			size = InputSize.Medium,
			variant = ButtonVariant.Utility,
			onActivated = props.onSearchOpen,
			LayoutOrder = 3,
			testId = "SearchButton"
		})
	})
	return createElement(
		View,
		{
			tag = "row flex-between align-y-center size-full-1200 padding-x-xlarge radius-medium bg-surface-0"
		},
		v3
	)
end

return TopBar
