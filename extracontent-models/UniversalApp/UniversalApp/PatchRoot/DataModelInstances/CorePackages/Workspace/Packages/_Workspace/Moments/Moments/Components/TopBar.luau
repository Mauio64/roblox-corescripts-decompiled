local Players = game:GetService("Players")
local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local BuilderIcons = require(MomentsParent.BuilderIcons)
local Foundation = require(MomentsParent.Foundation)
local Localization = require(MomentsParent.Localization)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local PlusLarge = BuilderIcons.Icon.PlusLarge
local ThreeBarsHorizontal = BuilderIcons.Icon.ThreeBarsHorizontal
local Coachmark = Foundation.Coachmark
local FoundationProvider = Foundation.FoundationProvider
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Theme = Foundation.Enums.Theme
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local NavigationMenu = require(Moments.Components.NavigationMenu)
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local useIsTvRemoteDevice = require(MomentsParent.RoactUtils).Hooks.useIsTvRemoteDevice
local useSetDrawerVisible = require(MomentsParent.Drawer).Hooks.useSetDrawerVisible
local Constants = require(Moments.Constants)
local GetFFlagMomentsImmersiveChrome = require(Moments.Flags.GetFFlagMomentsImmersiveChrome)
local useChromeRatio = require(Moments.Hooks.useChromeRatio)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local v32 = game:DefineFastFlag("MomentsAndroidTvEnabled", false)
local t1 = {
	defaultTitle = "Feature.Moments.Label.MomentsExperienceName"
}

local function ImmersiveHeaderChrome(t2: {[any]: any}) -- line: 77
	-- upvalues: useChromeRatio (copy), React (copy), Constants (copy), View (copy)
	local v37 = useChromeRatio()
	local v38, v39 = React.useBinding(0)
	local v40 = React.useCallback(function(p1) -- line: 80
		-- upvalues: v39 (copy)
		v39(p1.AbsoluteSize.Y)
	end, {})
	local v41 = React.joinBindings({
		ratio = v37,
		height = v38
	}):map(function(t3: {[any]: any}) -- line: 87
		return UDim2.new(0, 0, 0, (t3.ratio - 1) * t3.height)
	end)
	local v42 = v37:map(function(n1: number) -- line: 90
		return 1 - n1
	end)

	return React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t2.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = v41,
		GroupTransparency = v42,
		Interactable = v37:map(function(n2: number) -- line: 105
			return n2 > 0.01
		end),
		ZIndex = Constants.DisplayOrder.FeedTopBar,
		[React.Change.AbsoluteSize] = v40
	}, {
		Header = React.createElement(View, {
			tag = "size-full-0 auto-y"
		}, t2.children)
	})
end
local function TopBar(t4: {[any]: any}) -- line: 117
	-- upvalues: useLocalization (copy), t1 (copy), useTokens (copy), useDeviceInsets (copy), useSetDrawerVisible (copy), useIsTvRemoteDevice (copy), GetFFlagMomentsImmersiveChrome (copy), React (copy), Players (copy), fireAnalyticsEvent (copy), EventNames (copy), v32 (copy), IconButton (copy), PlusLarge (copy), ButtonVariant (copy), InputSize (copy), Coachmark (copy), Foundation (copy), ThreeBarsHorizontal (copy), FoundationText (copy), NavigationMenu (copy), View (copy), GradientBackdrop (copy), FoundationProvider (copy), Theme (copy), Constants (copy), ImmersiveHeaderChrome (copy)
	local v44 = useLocalization(t1)
	local v45 = useTokens()
	local v46 = useDeviceInsets()
	local v47 = useSetDrawerVisible()
	local v48 = useIsTvRemoteDevice()
	local v49 = GetFFlagMomentsImmersiveChrome()

	React.useEffect(function() -- line: 134
		-- upvalues: t4 (copy), Players (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if t4.showFtuxTooltip then
			local str = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId)

			fireAnalyticsEvent(EventNames.FTUXTooltipImpression, {
				userId = str,
				timestamp = tostring(os.time())
			})
		end
	end, { t4.showFtuxTooltip })

	local v50 = React.useCallback(function() -- line: 144
		-- upvalues: t4 (copy), fireAnalyticsEvent (copy), EventNames (copy), Players (copy)
		if t4.showFtuxTooltip then
			fireAnalyticsEvent(EventNames.FTUXTooltipDismissed, {
				userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
				timestamp = tostring(os.time())
			})
			t4.onFtuxTooltipDismissed()
		end

		t4.onCreatePressed()
	end, {
		t4.showFtuxTooltip,
		t4.onFtuxTooltipDismissed,
		t4.onCreatePressed
	})
	local v51 = React.useCallback(function() -- line: 157
		-- upvalues: v47 (copy)
		v47(true)
	end, { v47 })
	local v52 = not (v32 and v48)
	local v53 = React.createElement(IconButton, {
		LayoutOrder = 1,
		isCircular = true,
		Selectable = true,
		testId = "--moments-top-bar-create",
		icon = PlusLarge,
		onActivated = v50,
		variant = ButtonVariant.OverMedia,
		size = InputSize.Medium
	})
	local v54 = React.createElement(Coachmark, {
		LayoutOrder = 1,
		title = "Share Your First Moment",
		text = "Tap + to share a moment from your captures",
		isOpen = t4.showFtuxTooltip,
		onClose = function() -- line: 179
			-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), Players (copy), t4 (copy)
			fireAnalyticsEvent(EventNames.FTUXTooltipDismissed, {
				userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
				timestamp = tostring(os.time())
			})
			t4.onFtuxTooltipDismissed()
		end,
		side = Foundation.Enums.PopoverSide.Bottom,
		align = Foundation.Enums.PopoverAlign.End
	}, v53)
	local v55 = if not v52 then nil else React.createElement(IconButton, {
		LayoutOrder = 1,
		isCircular = true,
		Selectable = true,
		testId = "--moments-top-bar-hamburger",
		icon = ThreeBarsHorizontal,
		onActivated = v51,
		variant = ButtonVariant.OverMedia,
		size = InputSize.Medium
	})
	local v56 = React.createElement(FoundationText, {
		LayoutOrder = 2,
		tag = "shrink auto-xy text-heading-large text-truncate-end",
		Text = t4.title or v44.defaultTitle,
		textStyle = v45.Color.Content.Emphasis
	})
	local v57 = if not v52 then nil else {
		CreateMomentButton = if not t4.showFtuxTooltip then v53 else v54,
		NavigationMenu = React.createElement(NavigationMenu, {
			layoutOrder = 2,
			onNavigateToTrending = t4.onNavigateToTrending,
			onNavigateToMyMoments = t4.onNavigateToMyMoments
		})
	}
	local t5 = {
		LeftCluster = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-left align-y-center grow gap-small auto-y"
		}, {
			Hamburger = v55,
			MomentsTitle = v56
		}),
		RightCluster = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-right align-y-center gap-medium auto-xy"
		}, v57)
	}
	local t6 = {
		Spacer = React.createElement(View, {
			LayoutOrder = 1,
			tag = "grow auto-y"
		}),
		CloseButton = React.createElement(IconButton, {
			LayoutOrder = 2,
			icon = "icons/navigation/close_small",
			isCircular = true,
			Selectable = true,
			testId = "--moments-top-bar-close",
			onActivated = function() -- line: 251
				-- upvalues: t4 (copy)
				if t4.onClose then
					t4.onClose()
				end
			end,
			variant = ButtonVariant.OverMedia,
			size = InputSize.Medium
		})
	}
	local t7 = {
		GradientScrim = if not t4.showTopScrim then nil else React.createElement(GradientBackdrop, {
			startingTransparency = 0.4,
			endingTransparency = 1,
			rotation = 90,
			zIndex = 1,
			color3 = Color3.new(0, 0, 0),
			position = UDim2.fromScale(0, 0),
			size = UDim2.new(1, 0, 0, v46.top + v45.Size.Size_2000 + v45.Size.Size_1600)
		}),
		HeaderContent = React.createElement(View, {
			tag = "size-full-0 auto-y",
			ZIndex = 2,
			padding = {
				left = UDim.new(0, v46.left),
				right = UDim.new(0, v46.right),
				top = UDim.new(0, v46.top)
			}
		}, {
			OverMediaTheme = React.createElement(FoundationProvider, {
				theme = Theme.Light
			}, {
				HeaderRow = React.createElement(View, {
					tag = "row align-y-center size-full-0 auto-y padding-x-large padding-top-medium"
				}, if not t4.isBaseScreen then t6 else t5)
			})
		})
	}

	if not v49 then
		return React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = t4.layoutOrder,
			ZIndex = Constants.DisplayOrder.FeedTopBar
		}, t7)
	end

	return React.createElement(ImmersiveHeaderChrome, {
		layoutOrder = t4.layoutOrder
	}, t7)
end

return TopBar
