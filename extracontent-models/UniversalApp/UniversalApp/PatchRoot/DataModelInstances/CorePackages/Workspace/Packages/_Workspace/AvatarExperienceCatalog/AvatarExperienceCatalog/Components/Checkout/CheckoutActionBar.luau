local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local Responsive = require(Parent.Responsive)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local Constants = AvatarExperienceCommon.Constants
local FFlagStackedBottomNavMarketplaceCTA = require(Parent.SharedFlags).FFlagStackedBottomNavMarketplaceCTA
local useNavBarSize = require(Parent.AppNavBar).useNavBarSize

local function selectDeviceOrientation(p1) -- line: 20
	return p1.DeviceOrientation
end

local v12 = React.forwardRef(function(t1: {[any]: any}, p2) -- line: 35
	-- upvalues: Foundation (copy), FFlagStackedBottomNavMarketplaceCTA (copy), useNavBarSize (copy), useSelector (copy), selectDeviceOrientation (copy), Responsive (copy), useLocalization (copy), React (copy), Constants (copy)
	local v16 = Foundation.Hooks.useTokens()
	local v17 = if not FFlagStackedBottomNavMarketplaceCTA then nil else useNavBarSize()
	local v18 = useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait
	local v19 = useLocalization({
		checkoutItemSingular = "Feature.Catalog.Action.CheckoutSingular",
		checkoutButtonFtuxTooltip = "Feature.Catalog.Label.Checkout.CheckoutButtonFtuxTooltip",
		checkoutItemPlural = {
			"Feature.Catalog.Action.CheckoutPlural",
			count = t1.itemCount
		}
	})
	local v20 = React.useRef(nil)
	local v21 = React.useMemo(function() -- line: 51
		-- upvalues: v18 (copy), Constants (copy)
		if v18 then
			return (UDim2.fromScale(1, 0))
		end

		return (UDim2.fromScale(Constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE, 0))
	end, { v18 })
	local v22 = React.useMemo(function() -- line: 57
		-- upvalues: v18 (copy), Constants (copy)
		if v18 then
			return (UDim2.fromScale(0, 1))
		end

		return (UDim2.fromScale(Constants.LANDSCAPE_UI_WIDTH_PERCENTAGE, 1))
	end, { v18 })
	local v23 = if not FFlagStackedBottomNavMarketplaceCTA then v22 else React.useMemo(function() -- line: 64
		-- upvalues: t1 (copy), v22 (copy), v17 (copy)
		if t1.footerVisibilityBinding then
			return (t1.footerVisibilityBinding:map(function(p3) -- line: 66
				-- upvalues: v22 (copy), v17 (copy)
				return v22 + UDim2.new(0, 0, 0, -(v17 - 8) * p3)
			end))
		end

		return v22
	end, {
		v22,
		t1.footerVisibilityBinding,
		v17
	})

	return React.createElement(Foundation.View, {
		tag = "row items-center gap-medium auto-y padding-y-large padding-x-xlarge bg-surface-0 anchor-bottom-left",
		ZIndex = 3,
		ref = p2,
		Visible = t1.Visible,
		Size = v21,
		Position = v23,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged
	}, {
		ActionButton = React.createElement(Foundation.Button, {
			LayoutOrder = 1,
			text = if not (t1.itemCount <= 1) then v19.checkoutItemPlural else v19.checkoutItemSingular,
			onActivated = t1.onCheckoutButtonActivated,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			size = Foundation.Enums.ButtonSize.Medium,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			ref = v20
		}),
		ActionButtonPopover = React.createElement(Foundation.Popover.Root, {
			isOpen = t1.showCheckoutButtonTooltip
		}, {
			Anchor = React.createElement(Foundation.Popover.Anchor, {
				anchorRef = v20
			}),
			Content = React.createElement(Foundation.Popover.Content, {
				align = Foundation.Enums.PopoverAlign.Center,
				side = Foundation.Enums.PopoverSide.Top,
				radius = Foundation.Enums.Radius.Medium,
				backgroundStyle = v16.Color.System.Contrast
			}, {
				PopCoverContent = React.createElement(Foundation.View, {
					tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy"
				}, {
					CategoryButtonTooltipTitle = React.createElement(Foundation.Text, {
						tag = "auto-xy text-title-medium text-truncate-end content-inverse-emphasis",
						Text = v19.checkoutButtonFtuxTooltip
					}, {
						TooltipOverlayButton = React.createElement("TextButton", {
							Transparency = 1,
							[React.Event.Activated] = t1.onTooltipButtonActivated,
							Size = UDim2.fromScale(1, 1)
						})
					})
				})
			})
		}),
		ClearButton = React.createElement(Foundation.Button, {
			icon = "trash-can",
			LayoutOrder = 2,
			onActivated = t1.onClearButtonActivated,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.ButtonSize.Medium
		})
	})
end)

return React.memo(v12)
