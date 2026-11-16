local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local headerBar = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/UIBlox").App.Bar.HeaderBar
local chip = Foundation.Chip
local coachmark = Foundation.Coachmark
local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local chipSize = Foundation.Enums.ChipSize
local chipVariant = Foundation.Enums.ChipVariant
local inputSize = Foundation.Enums.InputSize

local plusLarge = BuilderIcons.Icon.PlusLarge
local chevronLargeLeft = BuilderIcons.Icon.ChevronLargeLeft

local gradientBackdrop = MomentsCommon.Components.GradientBackdrop
local flyoutLeftHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FlyoutSidePanel").Components.FlyoutLeftHeader
local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedExperimentDefinition").FlyoutSidePanelIXP
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/NavigationMenu")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local FFlagMomentsFtuxTooltipCreateCopy = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFtuxTooltipCreateCopy")
local FFlagMomentsFixFeedForDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixFeedForDeviceSafeInsets")
local shouldUseDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Display").shouldUseDeviceSafeInsets

local fFlagMomentsCreationFeatureGate = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsCreationFeatureGate

local function renderFeedTypeChips(feedTypeChips)
	local children = {}

	for k, item in feedTypeChips do
		children[`Chip_{item.id}`] = React.createElement(chip, {
			LayoutOrder = k,
			text = item.text,
			isChecked = item.isChecked,
			onActivated = item.onActivated,
			size = chipSize.Medium,
			variant = chipVariant.Standard,
			testId = `--moments-header--feed-chip--{item.id}`
		})
	end

	return React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "row align-y-center gap-small auto-xy",
			testId = "--moments-header--feed-chips"
		},
		children
	)
end

local function renderAction(p2, p3, onActivated, p4)
	return React.createElement(iconButton, {
		LayoutOrder = p4,
		icon = p3,
		onActivated = onActivated,
		variant = buttonVariant.Utility,
		size = inputSize.Medium,
		isCircular = true,
		Selectable = true,
		testId = `--moments-header--actions--{p2}`
	})
end

local function MomentsHeaderView(props)
	local fn
	local fn2
	local v5 = nil

	if props.variant == "back" then
		fn = function()
			return renderAction("back", chevronLargeLeft, props.onBack, 1)
		end

		if props.showInteractiveButtons and props.showNavigationMenu then
			local children = {}

			if props.showCreateButton then
				local onCreateMomentButtonPressed = props.onCreateMomentButtonPressed
				children.CreateMomentButton = React.createElement(iconButton, {
					LayoutOrder = 1,
					icon = plusLarge,
					onActivated = onCreateMomentButtonPressed,
					variant = buttonVariant.Utility,
					size = inputSize.Medium,
					isCircular = true,
					Selectable = true,
					testId = "--moments-header--actions--create"
				})
			end

			children.NavigationMenu = React.createElement(module5, {
				layoutOrder = 2,
				buttonTestId = "--moments-header--actions--more",
				buttonVariant = buttonVariant.Utility,
				onNavigateToTrending = props.onNavigateToTrending,
				onNavigateToMyMoments = props.onNavigateToMyMoments
			})

			fn2 = function()
				return React.createElement(
					view,
					{ tag = "row align-y-center gap-xsmall auto-xy" },
					children
				)
			end
		elseif props.showInteractiveButtons and props.showCreateButton then
			fn2 = function()
				return renderAction("create", plusLarge, props.onCreateMomentButtonPressed, 1)
			end
		end
	elseif props.variant == "base" then
		if props.feedTypeChips ~= nil then
			v5 = renderFeedTypeChips(props.feedTypeChips)
		end

		local flyoutSidePanelEnabled = flyoutSidePanelIXP.isFlyoutSidePanelEnabled()
		local v6 = props.showInteractiveButtons and props.showHamburger and flyoutSidePanelEnabled

		fn = function()
			if v6 then
				return React.createElement(flyoutLeftHeader, {
					titleText = props.title,
					isRobloxLogoEnabled = false,
					isFlyoutEntrypointEnabled = flyoutSidePanelEnabled,
					isAlternateEntryPointEnabled = flyoutSidePanelIXP.isAlternateEntryPointEnabled()
				})
			end

			return React.createElement(view, {
				tag = "row align-x-left align-y-center auto-xy"
			}, {
				Title = React.createElement(text, {
					Text = props.title,
					textStyle = props.titleTextStyle,
					tag = "auto-xy text-heading-large"
				})
			})
		end

		if props.showInteractiveButtons then
			local v7

			if props.showCreateButton or not fFlagMomentsCreationFeatureGate then
				local onCreateMomentButtonPressed = props.onCreateMomentButtonPressed
				local element = React.createElement(iconButton, {
					LayoutOrder = 1,
					icon = plusLarge,
					onActivated = onCreateMomentButtonPressed,
					variant = buttonVariant.Utility,
					size = inputSize.Medium,
					isCircular = true,
					Selectable = true,
					testId = "--moments-header--actions--create"
				})

				if props.showFtuxTooltip then
					local v9 = {
						LayoutOrder = 1,
						isOpen = props.showFtuxTooltip,
						onClose = props.onFtuxTooltipClosed,
						side = Foundation.Enums.PopoverSide.Bottom,
						title = not FFlagMomentsFtuxTooltipCreateCopy and "Share Your First Moment" or props.ftuxTooltipTitle,
						text = not FFlagMomentsFtuxTooltipCreateCopy and "Tap + to share a moment from your captures" or props.ftuxTooltipText,
						align = Foundation.Enums.PopoverAlign.End
					}

					v7 = React.createElement(coachmark, v9, element)
				else
					v7 = React.createElement(view, {
						LayoutOrder = 1,
						tag = "auto-xy"
					}, {
						Action = element
					})
				end
			else
				v7 = nil
			end

			fn2 = function()
				return React.createElement(view, {
					tag = "row align-y-center gap-xsmall auto-xy"
				}, {
					CreateMomentButton = v7,
					NavigationMenu = React.createElement(module5, {
						layoutOrder = 2,
						buttonTestId = "--moments-header--actions--more",
						buttonVariant = buttonVariant.Utility,
						onNavigateToTrending = props.onNavigateToTrending,
						onNavigateToMyMoments = props.onNavigateToMyMoments
					})
				})
			end
		end
	elseif props.variant == "close" then
		fn2 = function()
			return renderAction("close", "icons/navigation/close_small", props.onClose, 1)
		end
	end

	local v6 = {
		HeaderContent = React.createElement(
			view,
			{
				tag = "size-full-0 auto-y",
				testId = "--moments-header-content",
				ZIndex = 2
			},
			{
				SafeAreaContent = React.createElement(view, {
					padding = props.headerPadding,
					tag = {
						["size-full-0 auto-y"] = true,
						col = v5 ~= nil
					},
					testId = "--moments-header-safe-area"
				}, {
					FeedTypeChips = v5,
					HeaderBarContainer = React.createElement(
						view,
						{
							LayoutOrder = 1,
							tag = "size-full-0 auto-y",
							Size = UDim2.new(1, 0, 0, props.headerHeight),
							testId = "--moments-header"
						},
						{
							HeaderBar = React.createElement(headerBar, {
								barHeight = props.headerHeight,
								isTitleCentered = false,
								isOnMedia = false,
								backgroundTransparency = 1,
								paddingLeft = UDim.new(0, 0),
								paddingRight = UDim.new(0, 0),
								renderLeft = fn,
								renderRight = fn2,
								zIndex = 2
							})
						}
					)
				})
			}
		)
	}

	if props.showTopScrim then
		local createElement = React.createElement
		local v8 = {
			color3 = Color3.new(0, 0, 0),
			startingTransparency = 0.4,
			endingTransparency = 1,
			rotation = 90,
			position = 0,
			size = 0,
			zIndex = 1
		}

		local v9 = if FFlagMomentsFixFeedForDeviceSafeInsets and shouldUseDeviceSafeInsets then UDim2.fromOffset(0, props.scrimTopOffset or 0) else UDim2.fromScale(0, 0)
		v8.position = v9

		v8.size = UDim2.new(1, 0, 0, props.scrimHeight)
		v6.GradientScrim = createElement(gradientBackdrop, v8)
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "size-full-0",
			testId = "--moments-header-root",
			ZIndex = Constants.DisplayOrder.FeedTopBar
		},
		v6
	)
end

return MomentsHeaderView
