local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local BuilderIcons = require(MomentsParent.BuilderIcons)
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local HeaderBar = require(MomentsParent.UIBlox).App.Bar.HeaderBar
local Coachmark = Foundation.Coachmark
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local PlusLarge = BuilderIcons.Icon.PlusLarge
local ChevronLargeLeft = BuilderIcons.Icon.ChevronLargeLeft
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local FlyoutLeftHeader = require(MomentsParent.FlyoutSidePanel).Components.FlyoutLeftHeader
local FlyoutSidePanelIXP = require(MomentsParent.SharedExperimentDefinition).FlyoutSidePanelIXP
local NavigationMenu = require(Moments.Components.NavigationMenu)
local Constants = require(Moments.Constants)

local function renderAction(s1: string, p1, p2: ((...any) -> ...any), n1: number?) -- line: 60
	-- upvalues: React (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy)
	return React.createElement(IconButton, {
		isCircular = true,
		Selectable = true,
		LayoutOrder = n1,
		icon = p1,
		onActivated = p2,
		variant = ButtonVariant.Utility,
		size = InputSize.Medium,
		testId = `--moments-header--actions--{ s1 }`
	})
end
local function MomentsHeaderView(t1: {[any]: any}) -- line: 73
	-- upvalues: renderAction (copy), ChevronLargeLeft (copy), FlyoutSidePanelIXP (copy), React (copy), FlyoutLeftHeader (copy), View (copy), FoundationText (copy), PlusLarge (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy), Foundation (copy), Coachmark (copy), NavigationMenu (copy), HeaderBar (copy), GradientBackdrop (copy), Constants (copy)
	local v28 = nil
	local v29 = nil

	if t1.variant == "back" then
		function v28() -- line: 78
			-- upvalues: renderAction (copy), ChevronLargeLeft (copy), t1 (copy)
			return renderAction("back", ChevronLargeLeft, t1.onBack, 1)
		end
	elseif t1.variant == "base" then
		local v30 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
		local v31 = t1.showInteractiveButtons and (t1.showHamburger and v30)

		function v28() -- line: 87
			-- upvalues: v31 (copy), React (copy), FlyoutLeftHeader (copy), t1 (copy), v30 (copy), FlyoutSidePanelIXP (copy), View (copy), FoundationText (copy)
			if v31 then
				return React.createElement(FlyoutLeftHeader, {
					isRobloxLogoEnabled = false,
					titleText = t1.title,
					isFlyoutEntrypointEnabled = v30,
					isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
				})
			end

			return React.createElement(View, {
				tag = "row align-x-left align-y-center auto-xy"
			}, {
				Title = React.createElement(FoundationText, {
					tag = "auto-xy text-heading-large",
					Text = t1.title,
					textStyle = t1.titleTextStyle
				})
			})
		end

		if t1.showInteractiveButtons then
			local v32 = PlusLarge
			local onCreateMomentButtonPressed = t1.onCreateMomentButtonPressed
			local v34 = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				Selectable = true,
				testId = "--moments-header--actions--create",
				icon = v32,
				onActivated = onCreateMomentButtonPressed,
				variant = ButtonVariant.Utility,
				size = InputSize.Medium
			})
			local u36

			if t1.showFtuxTooltip then
				local t2 = {
					LayoutOrder = 1,
					title = "Share Your First Moment",
					text = "Tap + to share a moment from your captures",
					isOpen = t1.showFtuxTooltip,
					onClose = t1.onFtuxTooltipClosed,
					side = Foundation.Enums.PopoverSide.Bottom,
					align = Foundation.Enums.PopoverAlign.End
				}

				u36 = React.createElement(Coachmark, t2, v34)
			else
				u36 = React.createElement(View, {
					LayoutOrder = 1,
					tag = "auto-xy"
				}, {
					Action = v34
				})
			end

			function v29() -- line: 139
				-- upvalues: React (copy), View (copy), u36 (ref), NavigationMenu (copy), ButtonVariant (copy), t1 (copy)
				return React.createElement(View, {
					tag = "row align-y-center gap-xsmall auto-xy"
				}, {
					CreateMomentButton = u36,
					NavigationMenu = React.createElement(NavigationMenu, {
						layoutOrder = 2,
						buttonTestId = "--moments-header--actions--more",
						buttonVariant = ButtonVariant.Utility,
						onNavigateToTrending = t1.onNavigateToTrending,
						onNavigateToMyMoments = t1.onNavigateToMyMoments
					})
				})
			end
		end
	elseif t1.variant == "close" then
		function v29() -- line: 155
			-- upvalues: renderAction (copy), t1 (copy)
			return renderAction("close", "icons/navigation/close_small", t1.onClose, 1)
		end
	end

	local t3 = {
		HeaderContent = React.createElement(View, {
			tag = "size-full-0 auto-y",
			testId = "--moments-header-content",
			ZIndex = 2
		}, {
			SafeAreaContent = React.createElement(View, {
				tag = "size-full-0 auto-y",
				testId = "--moments-header-safe-area",
				padding = t1.headerPadding
			}, {
				HeaderBarContainer = React.createElement(View, {
					tag = "size-full-0 auto-y",
					testId = "--moments-header",
					Size = UDim2.new(1, 0, 0, t1.headerHeight)
				}, {
					HeaderBar = React.createElement(HeaderBar, {
						isTitleCentered = false,
						isOnMedia = false,
						backgroundTransparency = 1,
						zIndex = 2,
						barHeight = t1.headerHeight,
						paddingLeft = UDim.new(0, 0),
						paddingRight = UDim.new(0, 0),
						renderLeft = v28,
						renderRight = v29
					})
				})
			})
		})
	}

	if t1.showTopScrim then
		t3.GradientScrim = React.createElement(GradientBackdrop, {
			startingTransparency = 0.4,
			endingTransparency = 1,
			rotation = 90,
			zIndex = 1,
			color3 = Color3.new(0, 0, 0),
			position = UDim2.fromScale(0, 0),
			size = UDim2.new(1, 0, 0, t1.scrimHeight)
		})
	end

	return React.createElement(View, {
		tag = "size-full-0",
		testId = "--moments-header-root",
		LayoutOrder = t1.layoutOrder,
		ZIndex = Constants.DisplayOrder.FeedTopBar
	}, t3)
end

return MomentsHeaderView
