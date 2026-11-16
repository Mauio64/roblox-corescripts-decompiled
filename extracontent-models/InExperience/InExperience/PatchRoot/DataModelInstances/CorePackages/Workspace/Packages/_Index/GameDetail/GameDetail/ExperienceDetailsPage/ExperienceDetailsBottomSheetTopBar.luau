local parent = script:FindFirstAncestor("GameDetail").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local SharedFlags = require(parent.SharedFlags)

local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local v = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets

if v then
	local Display = require(parent.Display)
	v = Display.shouldUseDeviceSafeInsets
end

local function ExperienceDetailsBottomSheetTopBar(props)
	local tokens = props.tokens
	local navigation = props.navigation

	local v2, v3 = React.useBinding(0)
	local enabled, v4 = React.useBinding(false)

	local v5 = tokens.Padding.Small + tokens.Size.Size_100

	React.useEffect(function()
		local current = props.sheetContentRef.current

		if not current then
			v3(0)
			return
		end

		local function updateTopBarState() -- 1 equivalent call inferred from this helper
			v3(1 - math.clamp(
				(math.ceil(current.AbsolutePosition.Y) + props.deviceInsets.top - props.topBarHeight - v5) / math.max(props.fullH - props.briefH, 1),
				0,
				1
			))
		end

		updateTopBarState() -- inferred equivalent call
		local absolutePositionChangedConnection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateTopBarState)

		return function()
			absolutePositionChangedConnection:Disconnect()
		end
	end, {
		props.overlayFrame,
		props.deviceInsets.top,
		props.topBarHeight,
		v5,
		props.fullH,
		props.briefH
	})

	React.useEffect(function()
		v4(navigation.isFocused())

		local v6 = navigation.addListener(RoactNavigation.Events.WillFocus, function()
			v4(true)
		end)

		local v7 = navigation.addListener(RoactNavigation.Events.WillBlur, function()
			v4(false)
		end)

		return function()
			v6.remove()
			v7.remove()
		end
	end, { navigation })

	local createElement = React.createElement
	local v6 = {
		DisplayOrder = 1,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		ScreenInsets = 0,
		ClipToDeviceSafeArea = false,
		Enabled = 0
	}
	local screenInsets

	if v then
		screenInsets = Enum.ScreenInsets.DeviceSafeInsets
	else
		screenInsets = Enum.ScreenInsets.None
	end

	v6.ScreenInsets = screenInsets

	v6.Enabled = enabled

	local createElement2 = React.createElement
	local v7 = {
		Position = UDim2.new(0, 0, 0, not v and 0 or -props.deviceInsets.top),
		Size = UDim2.new(1, 0, 0, props.topBarHeight),
		BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
		Active = false,
		BackgroundTransparency = 0,
		GroupTransparency = props.shouldMountAsFullView and 0 or v2:map(function(p)
			return 1 - p
		end),
		BorderColor3 = tokens.Color.Common.Shimmer.Color3,
		BorderSizePixel = 0,
		ZIndex = 2
	}

	local createElement3 = React.createElement
	local view = Foundation.View
	local v8 = {
		tag = "row align-y-center size-full",
		padding = {
			top = UDim.new(0, props.deviceInsets.top),
			left = UDim.new(0, tokens.Padding.Large)
		}
	}

	local createElement4 = React.createElement
	local icon

	if props.shouldMountAsFullView then
		icon = IconName.ChevronLargeLeft
	else
		icon = IconName.X
	end

	local v9 = {
		icon = icon,
		variant = ButtonVariant.Utility,
		size = ButtonSize.Medium,
		isCircular = true,
		onActivated = 0,
		testId = "--discovery-edp-iconbutton-bottomsheet-nav"
	}
	local onActivated

	if props.shouldMountAsFullView then
		onActivated = props.onBack
	else
		onActivated = props.onClose
	end

	v9.onActivated = onActivated
	return createElement("ScreenGui", v6, {
		TopBarCanvasGroup = createElement2("CanvasGroup", v7, {
			TopBarOverlay = createElement3(view, v8, {
				TopBarButton = createElement4(IconButton, v9)
			})
		})
	})
end

return ExperienceDetailsBottomSheetTopBar
