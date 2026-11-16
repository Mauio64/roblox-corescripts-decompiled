local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local HeaderBar = UIBlox.App.Bar.HeaderBar
local Chip = Foundation.Chip
local Coachmark = Foundation.Coachmark
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local InputSize = Foundation.Enums.InputSize

local PlusLarge = BuilderIcons.Icon.PlusLarge
local ChevronLargeLeft = BuilderIcons.Icon.ChevronLargeLeft

local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local FlyoutSidePanel = require(parent.FlyoutSidePanel)
local FlyoutLeftHeader = FlyoutSidePanel.Components.FlyoutLeftHeader
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP
local NavigationMenu = require(Moments.Components.NavigationMenu)

local Constants = require(Moments.Constants)
local FFlagMomentsFtuxTooltipCreateCopy = require(Moments.Flags.FFlagMomentsFtuxTooltipCreateCopy)
local FFlagMomentsFixFeedForDeviceSafeInsets = require(Moments.Flags.FFlagMomentsFixFeedForDeviceSafeInsets)
local Display = require(parent.Display)
local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets

local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate

local function renderFeedTypeChips(feedTypeChips)
	local children = {}

	for k, item in feedTypeChips do
		children[`Chip_{item.id}`] = React.createElement(Chip, {
			LayoutOrder = k,
			text = item.text,
			isChecked = item.isChecked,
			onActivated = item.onActivated,
			size = ChipSize.Medium,
			variant = ChipVariant.Standard,
			testId = `--moments-header--feed-chip--{item.id}`
		})
	end

	return React.createElement(
		View,
		{
			LayoutOrder = 2,
			tag = "row align-y-center gap-small auto-xy",
			testId = "--moments-header--feed-chips"
		},
		children
	)
end

local function renderAction(p: string, icon, onActivated, layoutOrder: number?)
	return React.createElement(IconButton, {
		LayoutOrder = layoutOrder,
		icon = icon,
		onActivated = onActivated,
		variant = ButtonVariant.Utility,
		size = InputSize.Medium,
		isCircular = true,
		Selectable = true,
		testId = `--moments-header--actions--{p}`
	})
end

local function MomentsHeaderView(props)
	local fn
	local fn2
	local feedTypeChips = nil

	if props.variant == "back" then
		fn = function()
			return renderAction("back", ChevronLargeLeft, props.onBack, 1)
		end

		if props.showInteractiveButtons and props.showNavigationMenu then
			local children = {}

			if props.showCreateButton then
				local onCreateMomentButtonPressed = props.onCreateMomentButtonPressed
				children.CreateMomentButton = React.createElement(IconButton, {
					LayoutOrder = 1,
					icon = PlusLarge,
					onActivated = onCreateMomentButtonPressed,
					variant = ButtonVariant.Utility,
					size = InputSize.Medium,
					isCircular = true,
					Selectable = true,
					testId = "--moments-header--actions--create"
				})
			end

			children.NavigationMenu = React.createElement(NavigationMenu, {
				layoutOrder = 2,
				buttonTestId = "--moments-header--actions--more",
				buttonVariant = ButtonVariant.Utility,
				onNavigateToTrending = props.onNavigateToTrending,
				onNavigateToMyMoments = props.onNavigateToMyMoments
			})

			fn2 = function()
				return React.createElement(View, { tag = "row align-y-center gap-xsmall auto-xy" }, children)
			end
		elseif props.showInteractiveButtons and props.showCreateButton then
			fn2 = function()
				return renderAction("create", PlusLarge, props.onCreateMomentButtonPressed, 1)
			end
		end
	elseif props.variant == "base" then
		if props.feedTypeChips ~= nil then
			feedTypeChips = renderFeedTypeChips(props.feedTypeChips)
		end

		local flyoutSidePanelEnabled = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
		local v = props.showInteractiveButtons and props.showHamburger and flyoutSidePanelEnabled

		fn = function()
			if v then
				return React.createElement(FlyoutLeftHeader, {
					titleText = props.title,
					isRobloxLogoEnabled = false,
					isFlyoutEntrypointEnabled = flyoutSidePanelEnabled,
					isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
				})
			end

			return React.createElement(View, { tag = "row align-x-left align-y-center auto-xy" }, {
				Title = React.createElement(Text, {
					Text = props.title,
					textStyle = props.titleTextStyle,
					tag = "auto-xy text-heading-large"
				})
			})
		end

		if props.showInteractiveButtons then
			local createMomentButton

			if props.showCreateButton or not FFlagMomentsCreationFeatureGate then
				local onCreateMomentButtonPressed = props.onCreateMomentButtonPressed
				local element = React.createElement(IconButton, {
					LayoutOrder = 1,
					icon = PlusLarge,
					onActivated = onCreateMomentButtonPressed,
					variant = ButtonVariant.Utility,
					size = InputSize.Medium,
					isCircular = true,
					Selectable = true,
					testId = "--moments-header--actions--create"
				})

				if props.showFtuxTooltip then
					local v2 = {
						LayoutOrder = 1,
						isOpen = props.showFtuxTooltip,
						onClose = props.onFtuxTooltipClosed,
						side = Foundation.Enums.PopoverSide.Bottom,
						title = not FFlagMomentsFtuxTooltipCreateCopy and "Share Your First Moment" or props.ftuxTooltipTitle,
						text = not FFlagMomentsFtuxTooltipCreateCopy and "Tap + to share a moment from your captures" or props.ftuxTooltipText,
						align = Foundation.Enums.PopoverAlign.End
					}

					createMomentButton = React.createElement(Coachmark, v2, element)
				else
					createMomentButton = React.createElement(View, {
						LayoutOrder = 1,
						tag = "auto-xy"
					}, {
						Action = element
					})
				end
			else
				createMomentButton = nil
			end

			fn2 = function()
				return React.createElement(View, { tag = "row align-y-center gap-xsmall auto-xy" }, {
					CreateMomentButton = createMomentButton,
					NavigationMenu = React.createElement(NavigationMenu, {
						layoutOrder = 2,
						buttonTestId = "--moments-header--actions--more",
						buttonVariant = ButtonVariant.Utility,
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

	local v = {
		HeaderContent = React.createElement(
			View,
			{ tag = "size-full-0 auto-y", testId = "--moments-header-content", ZIndex = 2 },
			{
				SafeAreaContent = React.createElement(View, {
					padding = props.headerPadding,
					tag = {
						["size-full-0 auto-y"] = true,
						col = feedTypeChips ~= nil
					},
					testId = "--moments-header-safe-area"
				}, {
					FeedTypeChips = feedTypeChips,
					HeaderBarContainer = React.createElement(
						View,
						{
							LayoutOrder = 1,
							tag = "size-full-0 auto-y",
							Size = UDim2.new(1, 0, 0, props.headerHeight),
							testId = "--moments-header"
						},
						{
							HeaderBar = React.createElement(HeaderBar, {
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
		local v2 = {
			color3 = Color3.new(0, 0, 0),
			startingTransparency = 0.4,
			endingTransparency = 1,
			rotation = 90,
			position = 0,
			size = 0,
			zIndex = 1
		}
		local position

		if FFlagMomentsFixFeedForDeviceSafeInsets and shouldUseDeviceSafeInsets then
			position = UDim2.fromOffset(0, props.scrimTopOffset or 0)
		else
			position = UDim2.fromScale(0, 0)
		end

		v2.position = position

		v2.size = UDim2.new(1, 0, 0, props.scrimHeight)
		v.GradientScrim = createElement(GradientBackdrop, v2)
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "size-full-0",
			testId = "--moments-header-root",
			ZIndex = Constants.DisplayOrder.FeedTopBar
		},
		v
	)
end

return MomentsHeaderView
