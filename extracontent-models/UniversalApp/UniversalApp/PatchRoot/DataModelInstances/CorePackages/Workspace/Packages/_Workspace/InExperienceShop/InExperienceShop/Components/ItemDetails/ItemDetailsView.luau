local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local VerifiedBadges = require(InExperienceShopParent.VerifiedBadges)
local useLocalization = require(InExperienceShopParent.Localization).Hooks.useLocalization

require(InExperienceShop.Types)

local formatPrice = require(InExperienceShop.Utils.formatPrice)
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
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
local t1 = {
	owned = "Feature.Catalog.Label.Owned",
	buy = "Feature.Catalog.Action.Buy",
	total = "Feature.Catalog.Label.TotalUnformatted",
	category = "Feature.Catalog.Label.Category",
	updated = "Feature.GameDetails.Label.Updated",
	report = "Feature.Catalog.Action.Report",
	noDescription = "Feature.InExperienceShop.Label.NoDescription"
}

local function CreatorRow(t2: {[any]: any}) -- line: 81
	-- upvalues: VerifiedBadges (copy), React (copy), FoundationText (copy)
	local creator = t2.creator
	local v34 = if not creator.hasVerifiedBadge then creator.name else creator.name .. VerifiedBadges.emoji.verified

	return React.createElement(FoundationText, {
		tag = "size-full-0 auto-y text-body-large text-align-x-left text-truncate-end content-muted",
		testId = "ItemDetailsView_CreatorRow",
		Text = v34,
		LayoutOrder = t2.LayoutOrder
	})
end
local function DetailRow(t3: {[any]: any}) -- line: 93
	-- upvalues: React (copy), View (copy), FoundationText (copy)
	return React.createElement(View, {
		tag = "row flex-x-between align-y-center size-full-0 auto-y padding-y-medium",
		LayoutOrder = t3.LayoutOrder
	}, {
		Label = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium content-muted",
			LayoutOrder = 1,
			Text = t3.label
		}),
		Value = React.createElement(FoundationText, {
			tag = "auto-xy text-caption-large content-emphasis",
			LayoutOrder = 2,
			Text = t3.value
		})
	})
end
local function ItemDetailsView(t4: {[any]: any}) -- line: 115
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), DetailRow (copy), Divider (copy), View (copy), FoundationText (copy), CreatorRow (copy), Icon (copy), Constants (copy), IconSize (copy), formatPrice (copy), REPORT_MENU_ITEM_ID (copy), REPORT_ICON (copy), Menu (copy), InputSize (copy), PopoverSide (copy), PopoverAlign (copy), IconButton (copy), OVERFLOW_ICON (copy), ButtonVariant (copy), Button (copy), FillBehavior (copy), FoundationImage (copy), IconName (copy)
	local v37 = useLocalization(t1)
	local v38 = if t4.description == nil or t4.description == "" then v37.noDescription else t4.description
	local v39 = t4.isOwned == true
	local v40 = t4.isBuyDisabled == true
	local v41 = t4.price ~= nil
	local isCompact = t4.isCompact
	local t5 = {
		Category = React.createElement(DetailRow, {
			LayoutOrder = 1,
			label = v37.category,
			value = t4.categoryLabel
		}),
		CategoryDivider = React.createElement(Divider, {
			LayoutOrder = 2
		})
	}

	if t4.updated ~= nil and t4.updated ~= "" then
		t5.Updated = React.createElement(DetailRow, {
			LayoutOrder = 3,
			label = v37.updated,
			value = t4.updated
		})
		t5.UpdatedDivider = React.createElement(Divider, {
			LayoutOrder = 4
		})
	end

	local v44 = t4.creator ~= nil and (t4.creator.name ~= nil and t4.creator.name ~= "")
	local v45 = React.createElement(View, {
		tag = "col gap-xxsmall size-full-0 auto-y",
		LayoutOrder = 1
	}, {
		Name = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-heading-small text-align-x-left text-truncate-end content-emphasis",
			LayoutOrder = 1,
			Text = t4.name
		}),
		Creator = if not v44 then nil else React.createElement(CreatorRow, {
			LayoutOrder = 2,
			creator = t4.creator
		})
	})
	local v46 = React.createElement(FoundationText, {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
		LayoutOrder = 2,
		Text = v38
	})
	local v47 = React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = 3
	}, t5)
	local v48 = React.createElement(View, {
		tag = "row flex-x-between align-y-center size-full-0 auto-y",
		LayoutOrder = 2
	}, {
		TotalLabel = React.createElement(FoundationText, {
			tag = "auto-xy text-title-medium content-emphasis",
			LayoutOrder = 1,
			Text = v37.total
		}),
		Price = if not v41 then nil else React.createElement(View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 2
		}, {
			RobuxIcon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = Constants.ROBUX_ICON,
				size = IconSize.Small
			}),
			PriceLabel = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium content-default",
				LayoutOrder = 2,
				Text = formatPrice(t4.price)
			})
		})
	})
	local t6 = {}

	if t4.isReportingEnabled then
		table.insert(t6, {
			id = REPORT_MENU_ITEM_ID,
			icon = REPORT_ICON,
			text = v37.report
		})
	end

	local v50 = if not t4.isReportingEnabled then React.createElement(IconButton, {
		LayoutOrder = 2,
		testId = "ItemDetailsView_OverflowButton",
		icon = OVERFLOW_ICON,
		size = InputSize.Medium,
		variant = ButtonVariant.Standard,
		onActivated = t4.onOverflowActivated
	}) else React.createElement(Menu, {
		LayoutOrder = 2,
		testId = "ItemDetailsView_OverflowMenu",
		isOpen = t4.isOverflowMenuOpen,
		items = t6,
		size = InputSize.Medium,
		side = PopoverSide.Top,
		align = PopoverAlign.End,
		onPressedOutside = t4.onOverflowMenuClosed,
		onActivated = t4.onMenuItemActivated
	}, {
		Trigger = React.createElement(IconButton, {
			testId = "ItemDetailsView_OverflowButton",
			icon = OVERFLOW_ICON,
			size = InputSize.Medium,
			variant = ButtonVariant.Standard,
			onActivated = t4.onOverflowActivated
		})
	})
	local v51 = React.createElement(View, {
		tag = "row align-y-center gap-small size-full-0 auto-y",
		LayoutOrder = 3
	}, {
		Buy = React.createElement(Button, {
			LayoutOrder = 1,
			text = if not v39 then v37.buy else v37.owned,
			variant = if not v39 then ButtonVariant.Emphasis else ButtonVariant.Standard,
			size = InputSize.Medium,
			fillBehavior = FillBehavior.Fill,
			isDisabled = v39 or v40,
			onActivated = t4.onBuyActivated
		}),
		Overflow = v50
	})
	local v52 = React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-x-large padding-y-medium",
		LayoutOrder = not isCompact and 2 or 3
	}, {
		TopDivider = React.createElement(Divider, {
			LayoutOrder = 1
		}),
		TotalRow = v48,
		ActionRow = v51
	})
	local v55

	if isCompact then
		local v53 = React.createElement(View, {
			tag = "col align-x-center size-full-0 auto-y padding-x-xlarge padding-bottom-medium padding-top-large",
			LayoutOrder = 1
		}, {
			Thumbnail = React.createElement(FoundationImage, {
				tag = "radius-medium",
				Size = UDim2.fromOffset(180, 180),
				Image = t4.thumbnail,
				ScaleType = Enum.ScaleType.Fit
			})
		})
		local v54 = React.createElement(View, {
			tag = "col fill gap-large size-full-0 padding-x-xlarge padding-bottom-large",
			LayoutOrder = 2
		}, {
			TitleBlock = v45,
			Description = v46,
			DetailsList = v47
		})

		v55 = React.createElement(View, {
			tag = "col fill size-full-0",
			LayoutOrder = 2
		}, {
			Preview = v53,
			Info = v54,
			BuyBar = v52
		})
	else
		local v56 = React.createElement(View, {
			tag = "col fill gap-large size-full padding-x-xlarge padding-y-large",
			LayoutOrder = 1
		}, {
			TitleBlock = v45,
			Description = v46,
			DetailsList = v47
		})
		local v57 = React.createElement(View, {
			tag = "col",
			LayoutOrder = 2,
			Size = UDim2.new(0, 236, 1, 0)
		}, {
			Preview = React.createElement(View, {
				tag = "fill size-full-0 padding-large",
				LayoutOrder = 1
			}, {
				Thumbnail = React.createElement(FoundationImage, {
					tag = "size-full radius-medium",
					Image = t4.thumbnail,
					ScaleType = Enum.ScaleType.Fit
				})
			}),
			BuyBar = v52
		})

		v55 = React.createElement(View, {
			tag = "row align-y-top fill size-full-0",
			LayoutOrder = 2
		}, {
			LeftPane = v56,
			RightPane = v57
		})
	end

	return React.createElement(View, {
		tag = "col size-full",
		testId = "ItemDetailsView",
		onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
	}, {
		TopBarRow = React.createElement(View, {
			tag = "row align-y-center size-full-0 auto-y padding-x-medium padding-top-medium",
			LayoutOrder = 1
		}, {
			BackButton = React.createElement(IconButton, {
				isCircular = true,
				LayoutOrder = 1,
				testId = "ItemDetailsView_BackButton",
				icon = IconName.ChevronLargeLeft,
				size = InputSize.Medium,
				variant = ButtonVariant.Utility,
				onActivated = t4.onClose
			})
		}),
		Body = v55
	})
end

return ItemDetailsView
