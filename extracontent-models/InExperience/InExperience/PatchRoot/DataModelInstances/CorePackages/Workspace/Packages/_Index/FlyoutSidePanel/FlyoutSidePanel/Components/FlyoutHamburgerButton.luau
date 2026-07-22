local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local BuilderIcons = require(Parent.BuilderIcons)
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useSetDrawerVisible = require(Parent.Drawer).Hooks.useSetDrawerVisible
local FlyoutAlternateEntryPoint = require(script.Parent.FlyoutAlternateEntryPoint)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local UIBlox = require(Parent.UIBlox)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local FlyoutTooltipManager = require(script.Parent.Parent.FlyoutTooltipManager)
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local Flags = Foundation.Utility.Flags
local useTokens = Foundation.Hooks.useTokens
local FFlagLuaAppFixNotificationBadgeCountsSync = require(Parent.SharedFlags).FFlagLuaAppFixNotificationBadgeCountsSync
local FFlagEnableFlyoutOnNavRail = require(Parent.SharedFlags).FFlagEnableFlyoutOnNavRail

local function getTotalNotificationCount(p1, n1: number, n2: number) -- line: 38
	-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
	local n3 = 0

	if p1.MorePageSettings and p1.MorePageSettings > 0 then
		n3 += p1.MorePageSettings
	end

	if FFlagLuaAppFixNotificationBadgeCountsSync then
		if n1 > 0 then
			n3 += n1
		end

		if n2 > 0 then
			return n3 + n2
		end
	else
		if p1.MorePageFriends and p1.MorePageFriends > 0 then
			n3 += p1.MorePageFriends
		end

		if p1.MorePageMessages and p1.MorePageMessages > 0 then
			n3 += p1.MorePageMessages
		end
	end

	return n3
end
local function FlyoutHamburgerButton(t1: {[any]: any}) -- line: 65
	-- upvalues: useSetDrawerVisible (copy), useRoactService (copy), AppEventIngestService (copy), useSelector (copy), FFlagLuaAppFixNotificationBadgeCountsSync (copy), getTotalNotificationCount (copy), useTokens (copy), React (copy), FlyoutAnalytics (copy), FlyoutTooltipManager (copy), useLocalization (copy), CoreGui (copy), TooltipOrientation (copy), UserInputService (copy), FFlagEnableFlyoutOnNavRail (copy), Foundation (copy), StatusIndicator (copy), Flags (copy), StatusIndicatorVariant (copy), FlyoutAlternateEntryPoint (copy), Icon (copy), BuilderIcons (copy), IconSize (copy), withTooltip (copy)
	local v33 = useSetDrawerVisible()
	local v34 = useRoactService(AppEventIngestService)
	local v35 = useSelector(function(p2) -- line: 68
		return p2.NotificationBadgeCounts or {}
	end)
	local v36 = useSelector(function(p3) -- line: 71
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local FriendsCarousel = p3.FriendsCarousel
		local v54 = FriendsCarousel and (FriendsCarousel.Friends and FriendsCarousel.Friends.requests)

		return v54 and v54.receivedCount or 0
	end)
	local v37 = useSelector(function(p4) -- line: 79
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		return p4.SocialTab and p4.SocialTab.UnreadConversationCount or 0
	end)
	local v38 = getTotalNotificationCount(v35, v36, v37)
	local v39 = useTokens()
	local v40 = React.useCallback(function() -- line: 88
		-- upvalues: FlyoutAnalytics (copy), v34 (copy), t1 (copy), v33 (copy), FlyoutTooltipManager (copy)
		FlyoutAnalytics.sendPageLoadEvent(v34, t1.titleText)
		v33(true)
		FlyoutTooltipManager:flyoutSidePanelOpened()
	end, {})
	local v41, v42 = React.useState(FlyoutTooltipManager:isTooltipActive())
	local v43 = useLocalization({
		itemName = "CommonUI.Features.Label.More"
	})
	local v44 = useLocalization({
		body = "Feature.FlyoutSidePanel.Label.TooltipBody",
		title = {
			"Feature.FlyoutSidePanel.Label.TooltipTitle",
			itemName = v43.itemName
		}
	})
	local t2 = nil
	local t3 = nil

	if v41 then
		t2 = {
			active = true,
			DisplayOrder = 10,
			guiTarget = CoreGui,
			preferredOrientation = TooltipOrientation.Top
		}
		t3 = {
			useLargeDropShadow = false,
			headerRichText = true,
			headerText = v44.title,
			bodyText = v44.body,
			textAlignment = Enum.TextXAlignment.Left
		}
	end

	local v47 = React.useCallback(function(_) -- line: 120
		-- upvalues: v41 (copy), v42 (copy), FlyoutAnalytics (copy)
		if v41 then
			v42(false)
			FlyoutAnalytics.onFlyoutTooltipDismissed({
				source = "click"
			})
		end
	end, { v41 })

	React.useEffect(function() -- line: 128
		-- upvalues: v41 (copy), FlyoutTooltipManager (copy), FlyoutAnalytics (copy), UserInputService (copy), v47 (copy)
		local connection = nil

		if v41 then
			local v58 = FlyoutTooltipManager:getTooltipCount()

			FlyoutAnalytics.onFlyoutTooltipShown({
				count = v58
			})
			connection = UserInputService.InputBegan:Connect(v47)
		end

		return function() -- line: 135
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v41,
		v47
	})

	local v48 = if not t1.isAlternateEntryPointEnabled then if not FFlagEnableFlyoutOnNavRail or not t1.isIconCentered then UDim2.new(1, -v39.Size.Size_300, 0, v39.Size.Size_150) else UDim2.new(1, -v39.Size.Size_100, 0, v39.Size.Size_150) else if not FFlagEnableFlyoutOnNavRail or not t1.isIconCentered then UDim2.new(1, -v39.Size.Size_100, 0, v39.Size.Size_100) else UDim2.new(1, 0, 0, v39.Size.Size_100)
	local v49 = if not FFlagEnableFlyoutOnNavRail or not t1.isIconCentered then UDim2.new(0, 0, 0.5, 0) else UDim2.new(0.5, 0, 0.5, 0)
	local v50 = if not FFlagEnableFlyoutOnNavRail or not t1.isIconCentered then Vector2.new(0, 0.5) else Vector2.new(0.5, 0.5)

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		Size = UDim2.fromOffset(v39.Size.Size_1000, v39.Size.Size_1000),
		Selectable = if not FFlagEnableFlyoutOnNavRail then nil else t1.selectable,
		[React.Event.Activated] = v40,
		ref = t1.buttonRef
	}, {
		StatusIndicatorContainer = if not (v38 > 0) then nil else React.createElement(Foundation.View, {
			tag = "auto-xy padding-xxsmall radius-circle bg-surface-0",
			ZIndex = 2,
			Position = v48,
			AnchorPoint = Vector2.new(1, 0)
		}, {
			StatusIndicator = React.createElement(StatusIndicator, {
				variant = if not Flags.FoundationStatusIndicatorVariantExperiment then StatusIndicatorVariant.Emphasis else StatusIndicatorVariant.Contrast_Experiment
			})
		}),
		HamburgerButton = React.createElement(Foundation.View, {
			tag = "auto-xy",
			Position = v49,
			AnchorPoint = v50
		}, {
			Hamburger = if not t1.isAlternateEntryPointEnabled then React.createElement(Icon, {
				name = BuilderIcons.Icon.ThreeBarsHorizontal,
				size = IconSize.Large
			}) else React.createElement(FlyoutAlternateEntryPoint),
			Tooltip = if not v41 then nil else withTooltip(t3, t2, function(p6) -- line: 194
				-- upvalues: React (copy)
				return React.createElement("Frame", {
					Visible = false,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					[React.Change.AbsolutePosition] = p6,
					[React.Change.AbsoluteSize] = p6
				})
			end)
		})
	})
end

return FlyoutHamburgerButton
