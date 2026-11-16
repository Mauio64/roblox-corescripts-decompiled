local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Responsive")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useSelector

local constants = AvatarExperienceCommon.Constants
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags")
local fFlagStackedBottomNavMarketplaceCTA = SharedFlags.FFlagStackedBottomNavMarketplaceCTA
local fFlagAXFixBottomNavCTAHeight = SharedFlags.FFlagAXFixBottomNavCTAHeight
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local constants2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppSystemBar").Constants
local useNavBarSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppNavBar").useNavBarSize
local splitPaneStore = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SplitPane").SplitPaneStore else nil
local useSignalState = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState else nil

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local forwardRef = React.forwardRef(function(props, p2)
	local v5 = Foundation.Hooks.useTokens()
	local v6

	if fFlagStackedBottomNavMarketplaceCTA and not fFlagAXFixBottomNavCTAHeight then
		v6 = useNavBarSize()
	else
		v6 = nil
	end

	local v7

	if fFlagEnableSplitPane then
		v7 = useSignalState(splitPaneStore.getStore().getIsBreakpointEnabled)
	else
		v7 = false
	end

	local v8

	if fFlagEnableSplitPane then
		v8 = useSignalState(splitPaneStore.getStore().getSupportWidthFraction)
	else
		v8 = nil
	end

	local v9 = useSelector(selectDeviceOrientation)

	if fFlagEnableSplitPane and v7 then
		v9 = Responsive.Keys.Landscape
	end

	local v10 = v9 == Responsive.Keys.Portrait

	local v11 = useLocalization({
		checkoutItemSingular = "Feature.Catalog.Action.CheckoutSingular",
		checkoutItemPlural = {
			"Feature.Catalog.Action.CheckoutPlural",
			count = props.itemCount
		},
		checkoutButtonFtuxTooltip = "Feature.Catalog.Label.Checkout.CheckoutButtonFtuxTooltip"
	})

	local ref = React.useRef(nil)

	local v12 = React.useMemo(function()
		if v10 then
			return UDim2.fromScale(1, 0)
		end

		if not fFlagEnableSplitPane then
			return UDim2.fromScale(constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE, 0)
		end

		local v13 = if v7 then v8 else constants.LANDSCAPE_SCENE_WIDTH_PERCENTAGE
		return UDim2.fromScale(v13, 0)
	end, { v10, v7, v8 })

	local v13 = React.useMemo(function()
		if v10 then
			return UDim2.fromScale(0, 1)
		end

		if not fFlagEnableSplitPane then
			return UDim2.fromScale(constants.LANDSCAPE_UI_WIDTH_PERCENTAGE, 1)
		end

		local v14 = if v7 then 1 - v8 else constants.LANDSCAPE_UI_WIDTH_PERCENTAGE
		return UDim2.fromScale(v14, 1)
	end, { v10, v7, v8 })
	local v14

	if fFlagStackedBottomNavMarketplaceCTA then
		v14 = React.useMemo(function()
			if props.footerVisibilityBinding then
				return (props.footerVisibilityBinding:map(function(p3)
					if not fFlagAXFixBottomNavCTAHeight then
						return v13 + UDim2.new(0, 0, 0, -(v6 - 8) * p3)
					end

					local v15 = math.max(0, constants2.BOTTOM_BAR_SIZE * p3 - 8)
					return v13 + UDim2.new(0, 0, 0, -v15)
				end))
			end

			return v13
		end, { v13, props.footerVisibilityBinding, v6 })
	else
		v14 = v13
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v15 = {
		tag = "row items-center gap-medium auto-y padding-y-large padding-x-xlarge bg-surface-0 anchor-bottom-left",
		testId = fFlagEnableSplitPane and "CheckoutActionBar" or nil,
		ref = p2,
		Visible = props.Visible,
		Size = v12,
		Position = v14,
		ZIndex = 3,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
	}

	local createElement2 = React.createElement
	local button = Foundation.Button
	local v17 = if props.itemCount <= 1 then v11.checkoutItemSingular else v11.checkoutItemPlural
	return createElement(view, v15, {
		ActionButton = createElement2(button, {
			text = v17,
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
				Anchor = React.createElement(Foundation.Popover.Anchor, {
					anchorRef = ref
				}),
				Content = React.createElement(
					Foundation.Popover.Content,
					{
						align = Foundation.Enums.PopoverAlign.Center,
						side = Foundation.Enums.PopoverSide.Top,
						radius = Foundation.Enums.Radius.Medium,
						backgroundStyle = v5.Color.System.Contrast
					},
					{
						PopCoverContent = React.createElement(
							Foundation.View,
							{
								tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy"
							},
							{
								CategoryButtonTooltipTitle = React.createElement(
									Foundation.Text,
									{
										Text = v11.checkoutButtonFtuxTooltip,
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
