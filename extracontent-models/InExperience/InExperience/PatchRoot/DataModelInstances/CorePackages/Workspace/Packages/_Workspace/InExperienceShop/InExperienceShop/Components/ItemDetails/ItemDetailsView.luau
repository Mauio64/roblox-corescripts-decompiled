local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local VerifiedBadges = require(parent.VerifiedBadges)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(InExperienceShop.Types)

local formatPrice = require(InExperienceShop.Utils.formatPrice)

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Icon = Foundation.Icon
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local Divider = Foundation.Divider
local Menu = Foundation.Menu
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local IconSize = Foundation.Enums.IconSize
local FillBehavior = Foundation.Enums.FillBehavior
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local Constants = require(InExperienceShop.Constants)
local shopOverflowConstants = require(InExperienceShop.Components.Shared.shopOverflowConstants)
require(InExperienceShop.Hooks.useShopReportOverflow)

local OVERFLOW_ICON = shopOverflowConstants.OVERFLOW_ICON
local REPORT_ICON = shopOverflowConstants.REPORT_ICON
local REPORT_MENU_ITEM_ID = shopOverflowConstants.REPORT_MENU_ITEM_ID

local v = {
	owned = "Feature.Catalog.Label.Owned",
	buy = "Feature.Catalog.Action.Buy",
	try = "Feature.Catalog.Action.Try",
	total = "Feature.Catalog.Label.TotalUnformatted",
	category = "Feature.Catalog.Label.Category",
	updated = "Feature.GameDetails.Label.Updated",
	report = "Feature.Catalog.Action.Report",
	noDescription = "Feature.InExperienceShop.Label.NoDescription"
}

local function CreatorRow(p)
	local creator = p.creator
	local text

	if creator.hasVerifiedBadge then
		text = creator.name .. VerifiedBadges.emoji.verified
	else
		text = creator.name
	end

	return React.createElement(Text, {
		tag = "size-full-0 auto-y text-body-large text-align-x-left text-truncate-end content-muted",
		Text = text,
		LayoutOrder = p.LayoutOrder,
		testId = "ItemDetailsView_CreatorRow"
	})
end

local function DetailRow(props)
	return React.createElement(
		View,
		{
			tag = "row flex-x-between align-y-center size-full-0 auto-y padding-y-medium",
			LayoutOrder = props.LayoutOrder
		},
		{
			Label = React.createElement(Text, {
				tag = "auto-xy text-body-medium content-muted",
				Text = props.label,
				LayoutOrder = 1
			}),
			Value = React.createElement(Text, {
				tag = "auto-xy text-caption-large content-emphasis",
				Text = props.value,
				LayoutOrder = 2
			})
		}
	)
end

local function ItemDetailsView(props)
	local v2 = useLocalization(v)
	local text

	if props.description == nil or props.description == "" then
		text = v2.noDescription
	else
		text = props.description
	end

	local isOwned = props.isOwned == true
	local isBuyDisabled = props.isBuyDisabled == true
	local v3 = props.price ~= nil
	local isCompact = props.isCompact

	local children = {}
	children.Category = React.createElement(DetailRow, {
		label = v2.category,
		value = props.categoryLabel,
		LayoutOrder = 1
	})

	children.CategoryDivider = React.createElement(Divider, { LayoutOrder = 2 })

	if props.updated ~= nil and props.updated ~= "" then
		children.Updated = React.createElement(DetailRow, {
			label = v2.updated,
			value = props.updated,
			LayoutOrder = 3
		})

		children.UpdatedDivider = React.createElement(Divider, { LayoutOrder = 4 })
	end

	local v4

	if props.creator == nil or props.creator.name == nil then
		v4 = false
	else
		v4 = props.creator.name ~= ""
	end

	local createElement = React.createElement

	local v5 = {
		Name = React.createElement(Text, {
			tag = "size-full-0 auto-y text-heading-small text-align-x-left text-truncate-end content-emphasis",
			Text = props.name,
			LayoutOrder = 1
		}),
		Creator = 0
	}
	local creator

	if v4 then
		creator = React.createElement(CreatorRow, { creator = props.creator, LayoutOrder = 2 })
	end

	v5.Creator = creator
	local element = createElement(View, {
		tag = "col gap-xxsmall size-full-0 auto-y",
		LayoutOrder = 1
	}, v5)

	local element2 = React.createElement(Text, {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
		Text = text,
		LayoutOrder = 2
	})

	local element3 = React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 3 }, children)

	local createElement2 = React.createElement

	local v6 = {
		TotalLabel = React.createElement(Text, {
			tag = "auto-xy text-title-medium content-emphasis",
			Text = v2.total,
			LayoutOrder = 1
		}),
		Price = 0
	}
	local price

	if v3 then
		price = React.createElement(View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 2
		}, {
			RobuxIcon = React.createElement(Icon, {
				name = Constants.ROBUX_ICON,
				size = IconSize.Small,
				LayoutOrder = 1
			}),
			PriceLabel = React.createElement(Text, {
				tag = "auto-xy text-body-medium content-default",
				Text = formatPrice(props.price),
				LayoutOrder = 2
			})
		})
	end

	v6.Price = price
	local element4 = createElement2(
		View,
		{ tag = "row flex-x-between align-y-center size-full-0 auto-y", LayoutOrder = 2 },
		v6
	)

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
			LayoutOrder = 3,
			testId = "ItemDetailsView_OverflowMenu"
		}, {
			Trigger = React.createElement(IconButton, {
				icon = OVERFLOW_ICON,
				size = InputSize.Medium,
				variant = ButtonVariant.Standard,
				onActivated = props.onOverflowActivated,
				testId = "ItemDetailsView_OverflowButton"
			})
		})
	else
		overflow = React.createElement(IconButton, {
			icon = OVERFLOW_ICON,
			size = InputSize.Medium,
			variant = ButtonVariant.Standard,
			onActivated = props.onOverflowActivated,
			LayoutOrder = 3,
			testId = "ItemDetailsView_OverflowButton"
		})
	end

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local text2 = if isOwned then v2.owned else v2.buy
	local variant

	if isOwned then
		variant = ButtonVariant.Standard
	else
		variant = ButtonVariant.Emphasis
	end

	local v7 = {
		Buy = createElement4(Button, {
			text = text2,
			variant = variant,
			size = InputSize.Medium,
			fillBehavior = FillBehavior.Fill,
			isDisabled = isOwned or isBuyDisabled or props.isActionDisabled == true,
			onActivated = props.onBuyActivated,
			LayoutOrder = 1
		}),
		Try = 0,
		Overflow = 0
	}
	local try

	if props.showTry and not isOwned then
		try = React.createElement(Button, {
			text = v2.try,
			variant = ButtonVariant.Standard,
			size = InputSize.Medium,
			fillBehavior = FillBehavior.Fill,
			onActivated = props.onTryActivated or function() end,
			isLoading = props.isActionLoading,
			isDisabled = props.isActionDisabled == true and props.isActionLoading ~= true,
			LayoutOrder = 2
		})
	end

	v7.Try = try

	v7.Overflow = overflow
	local element5 = createElement3(
		View,
		{ tag = "row align-y-center gap-small size-full-0 auto-y", LayoutOrder = 3 },
		v7
	)

	local element6 = React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-x-large padding-y-medium",
		LayoutOrder = isCompact and 3 or 2
	}, {
		TopDivider = React.createElement(Divider, { LayoutOrder = 1 }),
		TotalRow = element4,
		ActionRow = element5
	})
	local body

	if isCompact then
		local element7 = React.createElement(
			View,
			{
				tag = "col align-x-center size-full-0 auto-y padding-x-xlarge padding-bottom-medium padding-top-large",
				LayoutOrder = 1
			},
			{
				Thumbnail = React.createElement(Image, {
					tag = "radius-medium",
					Size = UDim2.fromOffset(180, 180),
					Image = props.thumbnail,
					ScaleType = Enum.ScaleType.Fit
				})
			}
		)

		local element8 = React.createElement(
			View,
			{
				tag = "col fill gap-large size-full-0 padding-x-xlarge padding-bottom-large",
				LayoutOrder = 2
			},
			{ TitleBlock = element, Description = element2, DetailsList = element3 }
		)

		body = React.createElement(View, { tag = "col fill size-full-0", LayoutOrder = 2 }, {
			Preview = element7,
			Info = element8,
			BuyBar = element6
		})
	else
		local element7 = React.createElement(
			View,
			{
				tag = "col fill gap-large size-full padding-x-xlarge padding-y-large",
				LayoutOrder = 1
			},
			{ TitleBlock = element, Description = element2, DetailsList = element3 }
		)

		local element8 = React.createElement(View, {
			tag = "col",
			Size = UDim2.new(0, 236, 1, 0),
			LayoutOrder = 2
		}, {
			Preview = React.createElement(View, {
				tag = "fill size-full-0 padding-large",
				LayoutOrder = 1
			}, {
				Thumbnail = React.createElement(Image, {
					tag = "size-full radius-medium",
					Image = props.thumbnail,
					ScaleType = Enum.ScaleType.Fit
				})
			}),
			BuyBar = element6
		})

		body = React.createElement(View, {
			tag = "row align-y-top fill size-full-0",
			LayoutOrder = 2
		}, {
			LeftPane = element7,
			RightPane = element8
		})
	end

	return React.createElement(
		View,
		{
			tag = "col size-full",
			testId = "ItemDetailsView",
			onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
		},
		{
			TopBarRow = React.createElement(
				View,
				{
					tag = "row align-y-center size-full-0 auto-y padding-x-medium padding-top-medium",
					LayoutOrder = 1
				},
				{
					BackButton = React.createElement(IconButton, {
						icon = IconName.ChevronLargeLeft,
						isCircular = true,
						size = InputSize.Medium,
						variant = ButtonVariant.Utility,
						onActivated = props.onClose,
						LayoutOrder = 1,
						testId = "ItemDetailsView_BackButton"
					})
				}
			),
			Body = body
		}
	)
end

return ItemDetailsView
