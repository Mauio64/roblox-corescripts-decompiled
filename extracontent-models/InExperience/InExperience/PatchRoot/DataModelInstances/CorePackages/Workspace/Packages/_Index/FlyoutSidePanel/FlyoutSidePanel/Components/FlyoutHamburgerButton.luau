local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Drawer = require(parent.Drawer)
local useSetDrawerVisible = Drawer.Hooks.useSetDrawerVisible
local FlyoutAlternateEntryPoint = require(script.Parent.FlyoutAlternateEntryPoint)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local UIBlox = require(parent.UIBlox)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local FlyoutTooltipManager = require(script.Parent.Parent.FlyoutTooltipManager)
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local useOpenFlyoutSidePanel = require(script.Parent.Parent.Hooks.useOpenFlyoutSidePanel)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getTestId = RoactUtils.getTestId
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppFixNotificationBadgeCountsSync = SharedFlags.FFlagLuaAppFixNotificationBadgeCountsSync
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableFlyoutOnNavRail = SharedFlags2.FFlagEnableFlyoutOnNavRail
local SharedFlags3 = require(parent.SharedFlags)
local FFlagFlyoutUseOpenHook = SharedFlags3.FFlagFlyoutUseOpenHook
local SharedFlags4 = require(parent.SharedFlags)
local FFlagFlyoutHeaderFixPadding = SharedFlags4.FFlagFlyoutHeaderFixPadding
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppAddTestIdsForArrow = SharedFlags5.FFlagLuaAppAddTestIdsForArrow

local function getTotalNotificationCount(data, p: number, p2: number)
	local total = 0

	if data.MorePageSettings and data.MorePageSettings > 0 then
		total += data.MorePageSettings
	end

	if FFlagLuaAppFixNotificationBadgeCountsSync then
		if p > 0 then
			total += p
		end

		if p2 > 0 then
			return total + p2
		end
	else
		if data.MorePageFriends and data.MorePageFriends > 0 then
			total += data.MorePageFriends
		end

		if data.MorePageMessages and data.MorePageMessages > 0 then
			total += data.MorePageMessages
		end
	end

	return total
end

local function FlyoutHamburgerButton(props)
	local totalNotificationCount = getTotalNotificationCount(useSelector(function(p)
		return p.NotificationBadgeCounts or {}
	end), useSelector(function(p)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local friendsCarousel = p.FriendsCarousel
		local requests = friendsCarousel and friendsCarousel.Friends and friendsCarousel.Friends.requests
		return requests and requests.receivedCount or 0
	end), useSelector(function(p)
		if FFlagLuaAppFixNotificationBadgeCountsSync then
			return p.SocialTab and p.SocialTab.UnreadConversationCount or 0
		end

		return 0
	end))
	local v = useTokens()
	local v2

	if FFlagFlyoutUseOpenHook then
		v2 = useOpenFlyoutSidePanel(props.titleText)
	else
		local v3 = useSetDrawerVisible()
		local v4 = useRoactService(AppEventIngestService)
		v2 = React.useCallback(function()
			FlyoutAnalytics.sendPageLoadEvent(v4, props.titleText)
			v3(true)
			FlyoutTooltipManager:flyoutSidePanelOpened()
		end, {})
	end

	local state, setState = React.useState(FlyoutTooltipManager:isTooltipActive())
	local v3 = useLocalization({
		title = {
			"Feature.FlyoutSidePanel.Label.TooltipTitle",
			itemName = useLocalization({ itemName = "CommonUI.Features.Label.More" }).itemName
		},
		body = "Feature.FlyoutSidePanel.Label.TooltipBody"
	})
	local v4, v5

	if state then
		v4 = {
			active = true,
			guiTarget = CoreGui,
			DisplayOrder = 10,
			preferredOrientation = TooltipOrientation.Top
		}

		v5 = {
			headerText = v3.title,
			bodyText = v3.body,
			textAlignment = Enum.TextXAlignment.Left,
			useLargeDropShadow = false,
			headerRichText = true
		}
	end

	local v6 = React.useCallback(function(_)
		if state then
			setState(false)
			FlyoutAnalytics.onFlyoutTooltipDismissed({ source = "click" })
		end
	end, { state })

	React.useEffect(function()
		local inputBeganConnection

		if state then
			local tooltipCount = FlyoutTooltipManager:getTooltipCount()
			FlyoutAnalytics.onFlyoutTooltipShown({ count = tooltipCount })
			inputBeganConnection = UserInputService.InputBegan:Connect(v6)
		else
			inputBeganConnection = nil
		end

		return function()
			if inputBeganConnection then
				inputBeganConnection:Disconnect()
				inputBeganConnection = nil
			end
		end
	end, { state, v6 })
	local udim

	if props.isAlternateEntryPointEnabled then
		if FFlagEnableFlyoutOnNavRail and props.isIconCentered then
			udim = UDim2.new(1, 0, 0, v.Size.Size_100)
		else
			udim = UDim2.new(1, FFlagFlyoutHeaderFixPadding and 0 or -v.Size.Size_100, 0, v.Size.Size_100)
		end
	elseif FFlagEnableFlyoutOnNavRail and props.isIconCentered then
		udim = UDim2.new(1, -v.Size.Size_100, 0, v.Size.Size_150)
	else
		local v7

		if FFlagFlyoutHeaderFixPadding then
			v7 = -v.Size.Size_200
		else
			v7 = -v.Size.Size_300
		end

		udim = UDim2.new(1, v7, 0, v.Size.Size_150)
	end

	local udim2

	if FFlagEnableFlyoutOnNavRail and props.isIconCentered then
		udim2 = UDim2.new(0.5, 0, 0.5, 0)
	else
		udim2 = UDim2.new(0, 0, 0.5, 0)
	end

	local vector2

	if FFlagEnableFlyoutOnNavRail and props.isIconCentered then
		vector2 = Vector2.new(0.5, 0.5)
	else
		vector2 = Vector2.new(0, 0.5)
	end

	local createElement = React.createElement
	local v7

	if FFlagFlyoutHeaderFixPadding then
		v7 = v.Size.Size_900
	else
		v7 = v.Size.Size_1000
	end

	local v8 = {
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		Size = UDim2.fromOffset(v7, v.Size.Size_1000)
	}
	local selectable

	if FFlagEnableFlyoutOnNavRail then
		selectable = props.selectable
	end

	v8.Selectable = selectable
	v8[React.Event.Activated] = v2
	local tag = React.Tag
	local v9

	if FFlagLuaAppAddTestIdsForArrow then
		v9 = getTestId("core-ui-flyout-hamburger")
	end

	v8[tag] = v9
	v8.ref = props.buttonRef
	local statusIndicatorContainer

	if totalNotificationCount > 0 then
		statusIndicatorContainer = React.createElement(
			Foundation.View,
			{
				Position = udim,
				AnchorPoint = Vector2.new(1, 0),
				tag = "auto-xy padding-xxsmall radius-circle bg-surface-0",
				ZIndex = 2
			},
			{
				StatusIndicator = React.createElement(StatusIndicator, {
					variant = StatusIndicatorVariant.Emphasis
				})
			}
		)
	end

	local createElement2 = React.createElement
	local view = Foundation.View
	local hamburger

	if props.isAlternateEntryPointEnabled then
		hamburger = React.createElement(FlyoutAlternateEntryPoint)
	else
		hamburger = React.createElement(Icon, {
			name = BuilderIcons.Icon.ThreeBarsHorizontal,
			size = IconSize.Large
		})
	end

	local tooltip

	if state then
		tooltip = withTooltip(v5, v4, function(p)
			return React.createElement("Frame", {
				Visible = false,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[React.Change.AbsolutePosition] = p,
				[React.Change.AbsoluteSize] = p
			})
		end)
	end

	return createElement("TextButton", v8, {
		StatusIndicatorContainer = statusIndicatorContainer,
		HamburgerButton = createElement2(view, {
			Position = udim2,
			AnchorPoint = vector2,
			tag = "auto-xy"
		}, {
			Hamburger = hamburger,
			Tooltip = tooltip
		})
	})
end

return FlyoutHamburgerButton
