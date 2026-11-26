local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RoactNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")

local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant

local shouldUseDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets
	and require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Display").shouldUseDeviceSafeInsets

local function ExperienceDetailsBottomSheetTopBar(props)
	local tokens = props.tokens
	local navigation = props.navigation

	local v5, v6 = React.useBinding(0)
	local v7, v8 = React.useBinding(false)

	local v9 = tokens.Padding.Small + tokens.Size.Size_100

	React.useEffect(function()
		local current = props.sheetContentRef.current

		if not current then
			v6(0)
			return
		end

		local function updateTopBarState()
			v6(1 - math.clamp(
				(math.ceil(current.AbsolutePosition.Y) + props.deviceInsets.top - props.topBarHeight - v9) / math.max(props.fullH - props.briefH, 1),
				0,
				1
			))
		end

		v6(1 - math.clamp(
			(math.ceil(current.AbsolutePosition.Y) + props.deviceInsets.top - props.topBarHeight - v9) / math.max(props.fullH - props.briefH, 1),
			0,
			1
		))

		local absolutePositionChangedConnection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateTopBarState)

		return function()
			absolutePositionChangedConnection:Disconnect()
		end
	end, {
		props.overlayFrame,
		props.deviceInsets.top,
		props.topBarHeight,
		v9,
		props.fullH,
		props.briefH
	})

	React.useEffect(function()
		v8(navigation.isFocused())

		local v10 = navigation.addListener(RoactNavigation.Events.WillFocus, function()
			v8(true)
		end)

		local v11 = navigation.addListener(RoactNavigation.Events.WillBlur, function()
			v8(false)
		end)

		return function()
			v10.remove()
			v11.remove()
		end
	end, { navigation })

	local createElement = React.createElement
	local v11 = {
		DisplayOrder = 1,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		ScreenInsets = 0,
		ClipToDeviceSafeArea = false,
		Enabled = 0
	}

	local v12 = if shouldUseDeviceSafeInsets then Enum.ScreenInsets.DeviceSafeInsets else Enum.ScreenInsets.None
	v11.ScreenInsets = v12

	v11.Enabled = v7

	local createElement2 = React.createElement
	local v15 = {
		Position = UDim2.new(0, 0, 0, not shouldUseDeviceSafeInsets and 0 or -props.deviceInsets.top),
		Size = UDim2.new(1, 0, 0, props.topBarHeight),
		BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
		Active = false,
		BackgroundTransparency = 0,
		GroupTransparency = props.shouldMountAsFullView and 0 or v5:map(function(p2)
			return 1 - p2
		end),
		BorderColor3 = tokens.Color.Common.Shimmer.Color3,
		BorderSizePixel = 0,
		ZIndex = 2
	}

	local createElement3 = React.createElement
	local view = Foundation.View
	local v17 = {
		tag = "row align-y-center size-full",
		padding = {
			top = UDim.new(0, props.deviceInsets.top),
			left = UDim.new(0, tokens.Padding.Large)
		}
	}

	local createElement4 = React.createElement
	local v21 = if props.shouldMountAsFullView then iconName.ChevronLargeLeft else iconName.X
	local v20 = {
		icon = v21,
		variant = buttonVariant.Utility,
		size = buttonSize.Medium,
		isCircular = true,
		onActivated = 0,
		testId = "--discovery-edp-iconbutton-bottomsheet-nav"
	}

	local v22 = if props.shouldMountAsFullView then props.onBack else props.onClose
	v20.onActivated = v22
	return createElement("ScreenGui", v11, {
		TopBarCanvasGroup = createElement2("CanvasGroup", v15, {
			TopBarOverlay = createElement3(view, v17, {
				TopBarButton = createElement4(iconButton, v20)
			})
		})
	})
end

return ExperienceDetailsBottomSheetTopBar
