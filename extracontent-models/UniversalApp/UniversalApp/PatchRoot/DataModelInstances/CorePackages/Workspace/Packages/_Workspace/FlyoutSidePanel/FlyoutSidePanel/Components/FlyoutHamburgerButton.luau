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

local function getTotalNotificationCount(p1, n1: number, n2: number) -- line: 35
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
local function FlyoutHamburgerButton(t1: {[any]: any}) -- line: 62
	-- upvalues: useSetDrawerVisible (copy), useRoactService (copy), AppEventIngestService (copy), useSelector (copy), FFlagLuaAppFixNotificationBadgeCountsSync (copy), getTotalNotificationCount (copy), useTokens (copy), React (copy), FlyoutAnalytics (copy), FlyoutTooltipManager (copy), useLocalization (copy), CoreGui (copy), TooltipOrientation (copy), UserInputService (copy), Foundation (copy), StatusIndicator (copy), Flags (copy), StatusIndicatorVariant (copy), FlyoutAlternateEntryPoint (copy), Icon (copy), BuilderIcons (copy), IconSize (copy), withTooltip (copy)
	local v32 = useSetDrawerVisible()
	local v33 = useRoactService(AppEventIngestService)
	local v34 = useSelector(function(p2) -- line: 65
		return p2.NotificationBadgeCounts or {}
	end)
	local v35 = useSelector(function(p3) -- line: 68
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local FriendsCarousel = p3.FriendsCarousel
		local v51 = FriendsCarousel and (FriendsCarousel.Friends and FriendsCarousel.Friends.requests)

		return v51 and v51.receivedCount or 0
	end)
	local v36 = useSelector(function(p4) -- line: 76
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		return p4.SocialTab and p4.SocialTab.UnreadConversationCount or 0
	end)
	local v37 = getTotalNotificationCount(v34, v35, v36)
	local v38 = useTokens()
	local v39 = React.useCallback(function() -- line: 85
		-- upvalues: FlyoutAnalytics (copy), v33 (copy), t1 (copy), v32 (copy), FlyoutTooltipManager (copy)
		FlyoutAnalytics.sendPageLoadEvent(v33, t1.titleText)
		v32(true)
		FlyoutTooltipManager:flyoutSidePanelOpened()
	end, {})
	local v40, v41 = React.useState(FlyoutTooltipManager:isTooltipActive())
	local v42 = useLocalization({
		itemName = "CommonUI.Features.Label.More"
	})
	local v43 = useLocalization({
		body = "Feature.FlyoutSidePanel.Label.TooltipBody",
		title = {
			"Feature.FlyoutSidePanel.Label.TooltipTitle",
			itemName = v42.itemName
		}
	})
	local t2 = nil
	local t3 = nil

	if v40 then
		t2 = {
			active = true,
			DisplayOrder = 10,
			guiTarget = CoreGui,
			preferredOrientation = TooltipOrientation.Top
		}
		t3 = {
			useLargeDropShadow = false,
			headerRichText = true,
			headerText = v43.title,
			bodyText = v43.body,
			textAlignment = Enum.TextXAlignment.Left
		}
	end

	local v46 = React.useCallback(function(_) -- line: 117
		-- upvalues: v40 (copy), v41 (copy), FlyoutAnalytics (copy)
		if v40 then
			v41(false)
			FlyoutAnalytics.onFlyoutTooltipDismissed({
				source = "click"
			})
		end
	end, { v40 })

	React.useEffect(function() -- line: 125
		-- upvalues: v40 (copy), FlyoutTooltipManager (copy), FlyoutAnalytics (copy), UserInputService (copy), v46 (copy)
		local connection = nil

		if v40 then
			local v55 = FlyoutTooltipManager:getTooltipCount()

			FlyoutAnalytics.onFlyoutTooltipShown({
				count = v55
			})
			connection = UserInputService.InputBegan:Connect(v46)
		end

		return function() -- line: 132
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v40,
		v46
	})

	local v47 = if not t1.isAlternateEntryPointEnabled then UDim2.new(1, -v38.Size.Size_300, 0, v38.Size.Size_150) else UDim2.new(1, -v38.Size.Size_100, 0, v38.Size.Size_100)

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		Size = UDim2.fromOffset(v38.Size.Size_1000, v38.Size.Size_1000),
		[React.Event.Activated] = v39,
		ref = t1.buttonRef
	}, {
		StatusIndicatorContainer = if not (v37 > 0) then nil else React.createElement(Foundation.View, {
			tag = "auto-xy padding-xxsmall radius-circle bg-surface-0",
			ZIndex = 2,
			Position = v47,
			AnchorPoint = Vector2.new(1, 0)
		}, {
			StatusIndicator = React.createElement(StatusIndicator, {
				variant = if not Flags.FoundationStatusIndicatorVariantExperiment then StatusIndicatorVariant.Emphasis else StatusIndicatorVariant.Contrast_Experiment
			})
		}),
		HamburgerButton = React.createElement(Foundation.View, {
			tag = "auto-xy",
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5)
		}, {
			Hamburger = if not t1.isAlternateEntryPointEnabled then React.createElement(Icon, {
				name = BuilderIcons.Icon.ThreeBarsHorizontal,
				size = IconSize.Large
			}) else React.createElement(FlyoutAlternateEntryPoint),
			Tooltip = if not v40 then nil else withTooltip(t3, t2, function(p6) -- line: 179
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
