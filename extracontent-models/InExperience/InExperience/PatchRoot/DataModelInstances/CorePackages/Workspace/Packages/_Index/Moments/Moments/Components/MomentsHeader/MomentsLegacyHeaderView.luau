local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local BuilderIcons = require(MomentsParent.BuilderIcons)
local Foundation = require(MomentsParent.Foundation)
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
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local Theme = Foundation.Enums.Theme
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local NavigationMenu = require(Moments.Components.NavigationMenu)
local Constants = require(Moments.Constants)

require(script.Parent.MomentsHeaderView)

local function MomentsLegacyHeaderView(p1) -- line: 34
	-- upvalues: React (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), InputSize (copy), PlusLarge (copy), Foundation (copy), Coachmark (copy), FoundationText (copy), ThreeBarsHorizontal (copy), NavigationMenu (copy), View (copy), FoundationProvider (copy), Theme (copy), GradientBackdrop (copy), Constants (copy)
	local t1 = nil

	if p1.variant == "back" then
		t1 = {
			BackButton = React.createElement(IconButton, {
				isCircular = true,
				Selectable = true,
				testId = "--moments-back-header-back",
				icon = IconName.ChevronLargeLeft,
				onActivated = p1.onBack,
				variant = ButtonVariant.OverMedia,
				size = InputSize.Medium
			})
		}
	elseif p1.variant == "base" then
		local v24 = React.createElement(IconButton, {
			LayoutOrder = 1,
			isCircular = true,
			Selectable = true,
			testId = "--moments-top-bar-create",
			icon = PlusLarge,
			onActivated = p1.onCreateMomentButtonPressed,
			variant = ButtonVariant.OverMedia,
			size = InputSize.Medium
		})

		if p1.showFtuxTooltip then
			local t2 = {
				LayoutOrder = 1,
				title = "Share Your First Moment",
				text = "Tap + to share a moment from your captures",
				isOpen = p1.showFtuxTooltip,
				onClose = p1.onFtuxTooltipClosed,
				side = Foundation.Enums.PopoverSide.Bottom,
				align = Foundation.Enums.PopoverAlign.End
			}

			v24 = React.createElement(Coachmark, t2, v24)
		end

		local t3 = {
			MomentsTitle = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "shrink auto-xy text-heading-large text-truncate-end",
				Text = p1.title,
				textStyle = p1.titleTextStyle
			})
		}

		if p1.showInteractiveButtons and p1.showHamburger then
			t3.Hamburger = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				Selectable = true,
				testId = "--moments-top-bar-hamburger",
				icon = ThreeBarsHorizontal,
				onActivated = p1.onHamburgerPressed,
				variant = ButtonVariant.OverMedia,
				size = InputSize.Medium
			})
		end

		local t4 = nil

		if p1.showInteractiveButtons then
			t4 = {
				CreateMomentButton = v24,
				NavigationMenu = React.createElement(NavigationMenu, {
					layoutOrder = 2,
					onNavigateToTrending = p1.onNavigateToTrending,
					onNavigateToMyMoments = p1.onNavigateToMyMoments
				})
			}
		end

		t1 = {
			LeftCluster = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row align-x-left align-y-center grow gap-small auto-y"
			}, t3),
			RightCluster = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-x-right align-y-center gap-medium auto-xy"
			}, t4)
		}
	elseif p1.variant == "close" then
		t1 = {
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
				onActivated = p1.onClose,
				variant = ButtonVariant.OverMedia,
				size = InputSize.Medium
			})
		}
	end

	local t5 = {
		HeaderContent = React.createElement(View, {
			tag = "size-full-0 auto-y",
			ZIndex = 2,
			padding = p1.headerPadding
		}, {
			OverMediaTheme = React.createElement(FoundationProvider, {
				theme = Theme.Light
			}, {
				HeaderRow = React.createElement(View, {
					tag = "row align-y-center size-full-0 auto-y padding-x-large padding-top-medium"
				}, t1)
			})
		})
	}

	if p1.showTopScrim then
		t5.GradientScrim = React.createElement(GradientBackdrop, {
			startingTransparency = 0.4,
			endingTransparency = 1,
			rotation = 90,
			zIndex = 1,
			color3 = Color3.new(0, 0, 0),
			position = UDim2.fromScale(0, 0),
			size = UDim2.new(1, 0, 0, p1.scrimHeight)
		})
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = p1.layoutOrder,
		ZIndex = Constants.DisplayOrder.FeedTopBar
	}, t5)
end

return MomentsLegacyHeaderView
