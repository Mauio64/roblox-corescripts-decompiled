local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization
local useSetDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useSetDrawerVisible
local FlyoutAlternateEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutAlternateEntryPoint")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UIBlox")
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local FlyoutTooltipManager = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/FlyoutTooltipManager")
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local useOpenFlyoutSidePanel = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useOpenFlyoutSidePanel")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppHooks").useRoactService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactServiceTags").AppEventIngestService
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getTestId = RoactUtils.getTestId
local statusIndicator = Foundation.StatusIndicator
local statusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local useTokens = Foundation.Hooks.useTokens

local fFlagLuaAppFixNotificationBadgeCountsSync = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagLuaAppFixNotificationBadgeCountsSync
local fFlagEnableFlyoutOnNavRail = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagEnableFlyoutOnNavRail
local fFlagFlyoutUseOpenHook = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagFlyoutUseOpenHook
local fFlagFlyoutHeaderFixPadding = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagFlyoutHeaderFixPadding
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagLuaAppAddTestIdsForArrow

local function getTotalNotificationCount(data, p2, p3)
	local total = 0

	if data.MorePageSettings and data.MorePageSettings > 0 then
		total += data.MorePageSettings
	end

	if fFlagLuaAppFixNotificationBadgeCountsSync then
		if p2 > 0 then
			total += p2
		end

		if p3 > 0 then
			return total + p3
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
	local totalNotificationCount = getTotalNotificationCount(useSelector(function(p2)
		return p2.NotificationBadgeCounts or {}
	end), useSelector(function(p2)
		if not fFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local friendsCarousel = p2.FriendsCarousel
		local requests = friendsCarousel and friendsCarousel.Friends and friendsCarousel.Friends.requests
		return requests and requests.receivedCount or 0
	end), useSelector(function(p2)
		if fFlagLuaAppFixNotificationBadgeCountsSync then
			return p2.SocialTab and p2.SocialTab.UnreadConversationCount or 0
		end

		return 0
	end))
	local v8 = useTokens()
	local v9

	if fFlagFlyoutUseOpenHook then
		v9 = useOpenFlyoutSidePanel(props.titleText)
	else
		local v10 = useSetDrawerVisible()
		local v11 = useRoactService(appEventIngestService)
		v9 = React.useCallback(function()
			FlyoutAnalytics.sendPageLoadEvent(v11, props.titleText)
			v10(true)
			FlyoutTooltipManager:flyoutSidePanelOpened()
		end, {})
	end

	local state, setState = React.useState(FlyoutTooltipManager:isTooltipActive())
	local v11 = useLocalization({
		title = {
			"Feature.FlyoutSidePanel.Label.TooltipTitle",
			itemName = useLocalization({ itemName = "CommonUI.Features.Label.More" }).itemName
		},
		body = "Feature.FlyoutSidePanel.Label.TooltipBody"
	})
	local v12, v13

	if state then
		v12 = {
			active = true,
			guiTarget = CoreGui,
			DisplayOrder = 10,
			preferredOrientation = tooltipOrientation.Top
		}

		v13 = {
			headerText = v11.title,
			bodyText = v11.body,
			textAlignment = Enum.TextXAlignment.Left,
			useLargeDropShadow = false,
			headerRichText = true
		}
	end

	local v14 = React.useCallback(function(p2)
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
			inputBeganConnection = UserInputService.InputBegan:Connect(v14)
		else
			inputBeganConnection = nil
		end

		return function()
			if inputBeganConnection then
				inputBeganConnection:Disconnect()
				inputBeganConnection = nil
			end
		end
	end, { state, v14 })
	local udim

	if props.isAlternateEntryPointEnabled then
		if fFlagEnableFlyoutOnNavRail and props.isIconCentered then
			udim = UDim2.new(1, 0, 0, v8.Size.Size_100)
		else
			udim = UDim2.new(1, fFlagFlyoutHeaderFixPadding and 0 or -v8.Size.Size_100, 0, v8.Size.Size_100)
		end
	elseif fFlagEnableFlyoutOnNavRail and props.isIconCentered then
		udim = UDim2.new(1, -v8.Size.Size_100, 0, v8.Size.Size_150)
	else
		local newUDim2 = UDim2.new

		local v16 = if fFlagFlyoutHeaderFixPadding then -v8.Size.Size_200 else -v8.Size.Size_300
		udim = newUDim2(1, v16, 0, v8.Size.Size_150)
	end

	local udim2

	if fFlagEnableFlyoutOnNavRail and props.isIconCentered then
		udim2 = UDim2.new(0.5, 0, 0.5, 0)
	else
		udim2 = UDim2.new(0, 0, 0.5, 0)
	end

	local vector2

	if fFlagEnableFlyoutOnNavRail and props.isIconCentered then
		vector2 = Vector2.new(0.5, 0.5)
	else
		vector2 = Vector2.new(0, 0.5)
	end

	local createElement = React.createElement

	local fromOffset = UDim2.fromOffset
	local v17 = if fFlagFlyoutHeaderFixPadding then v8.Size.Size_900 else v8.Size.Size_1000
	local v16 = {
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		Size = fromOffset(v17, v8.Size.Size_1000)
	}

	local v18 = if fFlagEnableFlyoutOnNavRail then props.selectable else nil
	v16.Selectable = v18
	v16[React.Event.Activated] = v9
	local tag = React.Tag
	local v19 = if fFlagLuaAppAddTestIdsForArrow then getTestId("core-ui-flyout-hamburger") else nil
	v16[tag] = v19
	v16.ref = props.buttonRef

	local v21 = if totalNotificationCount > 0 then React.createElement(
		Foundation.View,
		{
			Position = udim,
			AnchorPoint = Vector2.new(1, 0),
			tag = "auto-xy padding-xxsmall radius-circle bg-surface-0",
			ZIndex = 2
		},
		{
			StatusIndicator = React.createElement(statusIndicator, {
				variant = statusIndicatorVariant.Emphasis
			})
		}
	) else nil

	local createElement2 = React.createElement
	local view = Foundation.View

	local v24 = if props.isAlternateEntryPointEnabled then React.createElement(FlyoutAlternateEntryPoint) else React.createElement(icon, {
		name = BuilderIcons.Icon.ThreeBarsHorizontal,
		size = iconSize.Large
	})
	local v25

	if state then
		v25 = withTooltip(v13, v12, function(p2)
			return React.createElement("Frame", {
				Visible = false,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[React.Change.AbsolutePosition] = p2,
				[React.Change.AbsoluteSize] = p2
			})
		end)
	end

	return createElement("TextButton", v16, {
		StatusIndicatorContainer = v21,
		HamburgerButton = createElement2(
			view,
			{ Position = udim2, AnchorPoint = vector2, tag = "auto-xy" },
			{ Hamburger = v24, Tooltip = v25 }
		)
	})
end

return FlyoutHamburgerButton
