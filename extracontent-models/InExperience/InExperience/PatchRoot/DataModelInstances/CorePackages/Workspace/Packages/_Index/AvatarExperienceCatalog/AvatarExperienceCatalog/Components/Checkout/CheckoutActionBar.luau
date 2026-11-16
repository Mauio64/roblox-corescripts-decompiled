local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local Responsive = require(parent.Responsive)
local Localization = require(parent.Localization)

local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Constants = AvatarExperienceCommon.Constants
local SharedFlags = require(parent.SharedFlags)
local FFlagStackedBottomNavMarketplaceCTA = SharedFlags.FFlagStackedBottomNavMarketplaceCTA
local FFlagAXFixBottomNavCTAHeight = SharedFlags.FFlagAXFixBottomNavCTAHeight
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local AppSystemBar = require(parent.AppSystemBar)
local constants = AppSystemBar.Constants
local AppNavBar = require(parent.AppNavBar)
local useNavBarSize = AppNavBar.useNavBarSize
local splitPaneStore

if FFlagEnableSplitPane then
	local SplitPane = require(parent.SplitPane)
	splitPaneStore = SplitPane.SplitPaneStore
else
	splitPaneStore = nil
end

local useSignalState

if FFlagEnableSplitPane then
	local SignalsReact = require(parent.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local function selectDeviceOrientation(p)
	return p.DeviceOrientation
end

local forwardRef = React.forwardRef(function(props, ref2)
	local v = Foundation.Hooks.useTokens()
	local v2

	if FFlagStackedBottomNavMarketplaceCTA and not FFlagAXFixBottomNavCTAHeight then
		v2 = useNavBarSize()
	else
		v2 = nil
	end

	local v3

	if FFlagEnableSplitPane then
		v3 = useSignalState(splitPaneStore.getStore().getIsBreakpointEnabled)
	else
		v3 = false
	end

	local v4

	if FFlagEnableSplitPane then
		v4 = useSignalState(splitPaneStore.getStore().getSupportWidthFraction)
	else
		v4 = nil
	end

	local v5 = useSelector(selectDeviceOrientation)

	if FFlagEnableSplitPane and v3 then
		v5 = Responsive.Keys.Landscape
	end

	local v6 = v5 == Responsive.Keys.Portrait

	local v7 = useLocalization({
		checkoutItemSingular = "Feature.Catalog.Action.CheckoutSingular",
		checkoutItemPlural = {
			"Feature.Catalog.Action.CheckoutPlural",
			count = props.itemCount
		},
		checkoutButtonFtuxTooltip = "Feature.Catalog.Label.Checkout.CheckoutButtonFtuxTooltip"
	})

	local ref = React.useRef(nil)

	local size = React.useMemo(function()
		if v6 then
			return UDim2.fromScale(1, 0)
		end

		if not FFlagEnableSplitPane then
			return UDim2.fromScale(Constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE, 0)
		end

		local v8

		if v3 then
			v8 = v4
		else
			v8 = Constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE
		end

		return UDim2.fromScale(v8, 0)
	end, { v6, v3, v4 })

	local v8 = React.useMemo(function()
		if v6 then
			return UDim2.fromScale(0, 1)
		end

		if not FFlagEnableSplitPane then
			return UDim2.fromScale(Constants.LANDSCAPE_UI_WIDTH_PERCENTAGE, 1)
		end

		local v8

		if v3 then
			v8 = 1 - v4
		else
			v8 = Constants.LANDSCAPE_UI_WIDTH_PERCENTAGE
		end

		return UDim2.fromScale(v8, 1)
	end, { v6, v3, v4 })
	local position

	if FFlagStackedBottomNavMarketplaceCTA then
		position = React.useMemo(function()
			if props.footerVisibilityBinding then
				return (props.footerVisibilityBinding:map(function(p)
					if not FFlagAXFixBottomNavCTAHeight then
						return v8 + UDim2.new(0, 0, 0, -(v2 - 8) * p)
					end

					local v9 = math.max(0, constants.BOTTOM_BAR_SIZE * p - 8)
					return v8 + UDim2.new(0, 0, 0, -v9)
				end))
			end

			return v8
		end, { v8, props.footerVisibilityBinding, v2 })
	else
		position = v8
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v9 = {
		tag = "row items-center gap-medium auto-y padding-y-large padding-x-xlarge bg-surface-0 anchor-bottom-left",
		testId = FFlagEnableSplitPane and "CheckoutActionBar" or nil,
		ref = ref2,
		Visible = props.Visible,
		Size = size,
		Position = position,
		ZIndex = 3,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
	}

	local createElement2 = React.createElement
	local button = Foundation.Button
	local text

	if props.itemCount <= 1 then
		text = v7.checkoutItemSingular
	else
		text = v7.checkoutItemPlural
	end

	return createElement(view, v9, {
		ActionButton = createElement2(button, {
			text = text,
			onActivated = props.onCheckoutButtonActivated,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			size = Foundation.Enums.ButtonSize.Medium,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 1,
			ref = ref
		}),
		ActionButtonPopover = React.createElement(
			Foundation.Popover.Root,
			{ isOpen = props.showCheckoutButtonTooltip },
			{
				Anchor = React.createElement(Foundation.Popover.Anchor, { anchorRef = ref }),
				Content = React.createElement(
					Foundation.Popover.Content,
					{
						align = Foundation.Enums.PopoverAlign.Center,
						side = Foundation.Enums.PopoverSide.Top,
						radius = Foundation.Enums.Radius.Medium,
						backgroundStyle = v.Color.System.Contrast
					},
					{
						PopCoverContent = React.createElement(
							Foundation.View,
							{ tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy" },
							{
								CategoryButtonTooltipTitle = React.createElement(
									Foundation.Text,
									{
										Text = v7.checkoutButtonFtuxTooltip,
										tag = "auto-xy text-title-medium text-truncate-end content-inverse-emphasis"
									},
									{
										TooltipOverlayButton = React.createElement("TextButton", {
											Transparency = 1,
											[React.Event.Activated] = props.onTooltipButtonActivated,
											Size = UDim2.fromScale(1, 1)
										})
									}
								)
							}
						)
					}
				)
			}
		),
		ClearButton = React.createElement(Foundation.Button, {
			icon = "trash-can",
			onActivated = props.onClearButtonActivated,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.ButtonSize.Medium,
			LayoutOrder = 2
		})
	})
end)

return React.memo(forwardRef)
