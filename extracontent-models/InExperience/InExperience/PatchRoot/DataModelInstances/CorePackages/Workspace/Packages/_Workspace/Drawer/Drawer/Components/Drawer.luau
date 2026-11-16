local drawer = script:FindFirstAncestor("Drawer")
local UserInputService = game:GetService("UserInputService")
local parent = drawer.Parent
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)
local Foundation = require(parent.Foundation)
local ReactOtter = require(parent.ReactOtter)
local Signals = require(parent.Signals)
local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)
local useSetDrawerVisible = require(script.Parent.Parent.Hooks.useSetDrawerVisible)
local useSetDrawerShouldMount = require(script.Parent.Parent.Hooks.useSetDrawerShouldMount)
local useSetDrawerAnimating = require(script.Parent.Parent.Hooks.useSetDrawerAnimating)
local Scrim = require(script.Parent.Scrim)
local Constants = require(script.Parent.Parent.Constants)
require(script.Parent.Parent.Types)
local Enum2 = require(script.Parent.Parent.Enum)
local DrawerPanelStatus = Enum2.DrawerPanelStatus

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local FFlagEnableDrawerAnimatingHook = SharedFlags.FFlagEnableDrawerAnimatingHook
local FFlagSideSheetOpenPeoplePage = SharedFlags.FFlagSideSheetOpenPeoplePage
local FFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets
local Flags = require(drawer.Flags)
local FFlagFixDrawerNavigateBackWhileClosing = Flags.FFlagFixDrawerNavigateBackWhileClosing
local focusNavigableSurfaceWrapper, focusNavigableSurfaceIdentifierEnum, focusNavigationEventNameEnum, InputHandlers

if FFlagEnableDrawerFocusNav then
	local FocusNavigationUtils = require(parent.FocusNavigationUtils)
	focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
	focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
	focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
	InputHandlers = require(parent.InputHandlers)
else
	focusNavigationEventNameEnum = nil
	InputHandlers = nil
	focusNavigableSurfaceWrapper = nil
	focusNavigableSurfaceIdentifierEnum = nil
end

local function fn(props)
	local v = useSetDrawerVisible()
	local v2 = useSetDrawerShouldMount()

	local fn2 = not FFlagEnableDrawerAnimatingHook and function(_: boolean) end or useSetDrawerAnimating()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v3, v4 = React.useBinding(DrawerPanelStatus.Scrollable)
	local v5 = React.useMemo(function()
		return v3:map(function(p): boolean
			return p == DrawerPanelStatus.Scrollable
		end)
	end, {})

	local zIndex = React.useMemo(function()
		return v3:map(function(p): number
			return if p == DrawerPanelStatus.Movable then 3 else 1
		end)
	end, {})
	local backgroundColor

	if FFlagEnableDrawerFocusNav then
		backgroundColor = React.useMemo(function()
			local backgroundStyle = props.backgroundStyle

			if backgroundStyle == nil then
				return nil
			end

			if ReactIs.isBinding(backgroundStyle) then
				return backgroundStyle:map(function(p)
					return p.Color3
				end)
			end

			return backgroundStyle.Color3
		end, { props.backgroundStyle })
	end

	local backgroundTransparency

	if FFlagEnableDrawerFocusNav then
		backgroundTransparency = React.useMemo(function()
			local backgroundStyle = props.backgroundStyle

			if backgroundStyle == nil then
				return nil
			end

			if ReactIs.isBinding(backgroundStyle) then
				return backgroundStyle:map(function(p)
					return p.Transparency
				end)
			end

			return backgroundStyle.Transparency
		end, { props.backgroundStyle })
	end

	local topOffset = props.topOffset or 0
	local bottomOffset = props.bottomOffset or 0
	local leftOffset = props.leftOffset or 0
	local deviceSafeInsets

	if FFlagFixOverlayTopInsetForDeviceSafeInsets then
		deviceSafeInsets = props.deviceSafeInsets
	end

	local clipsDescendants = FFlagSideSheetOpenPeoplePage and props.allowOutsideInteraction == true
	local current2 = props.menuWidth + leftOffset
	local ref3 = React.useRef(false)
	local v6 = React.useCallback(function(p)
		if FFlagEnableDrawerAnimatingHook then
			fn2(false)
		end

		if v3:getValue() == DrawerPanelStatus.Closing then
			v4(DrawerPanelStatus.Scrollable)
		end

		if p == -current2 then
			v2(false)
		end
	end, (FFlagSideSheetOpenPeoplePage or FFlagEnableDrawerAnimatingHook) and { current2, fn2, v2 } or {})

	local menuPosX, v7 = ReactOtter.useAnimatedBinding(-current2, v6)

	local ref4 = React.useRef(current2)
	ref4.current = current2

	local ref5 = React.useRef(nil)
	local v8, v9 = ReactOtter.useAnimatedBinding(1)
	local v10

	if FFlagSideSheetOpenPeoplePage then
		v10 = React.useCallback(function(p): boolean
			local current = ref5.current

			if current == nil then
				return false
			end

			local position = p.Position
			local absolutePosition = current.AbsolutePosition
			local absoluteSize = current.AbsoluteSize
			return position.X >= absolutePosition.X
				and position.X <= absolutePosition.X + absoluteSize.X
				and position.Y >= absolutePosition.Y
				and position.Y <= absolutePosition.Y + absoluteSize.Y
		end, {})
	else
		v10 = nil
	end

	local useCallback = React.useCallback
	local function fn3(source)
		v(false)
		v4(DrawerPanelStatus.Closing)

		if props.onDrawerClosedAnalytics then
			props.onDrawerClosedAnalytics({ source = source })
		end
	end

	local v11

	if FFlagSideSheetOpenPeoplePage then
		v11 = { props.onDrawerClosedAnalytics, v }
	else
		v11 = { props.onDrawerClosedAnalytics }
	end

	local v12 = useCallback(fn3, v11)

	local v13 = React.useCallback(function(p)
		if not ref3.current or v3:getValue() == DrawerPanelStatus.Closing or clipsDescendants and not v10(p) then
			return
		end

		ref.current = p.Position
		ref2.current = DateTime.now().UnixTimestampMillis
		v4(DrawerPanelStatus.Static)
	end, FFlagSideSheetOpenPeoplePage and { clipsDescendants, v10 } or {})

	local v14 = React.useCallback(function(p)
		if
			ref3.current
			and ref.current ~= nil
			and ref2.current ~= nil
			and v3:getValue() == DrawerPanelStatus.Movable
		then
			local v14 = ref.current.X - p.Position.X

			if ref4.current * Constants.DRAWER_SWIPE_THRESHOLD_PERCENT <= v14 then
				v12("swipe")
			elseif v14 > 0 then
				local v15 = (DateTime.now().UnixTimestampMillis - ref2.current) / 1000

				if v15 > 0.01 and v14 / v15 >= Constants.DRAWER_VELOCITY_THRESHOLD then
					v12("swipe")
				end
			end

			if v3:getValue() ~= DrawerPanelStatus.Closing then
				if FFlagEnableDrawerAnimatingHook then
					fn2(true)
				end

				v7(ReactOtter.ease(0, Constants.DRAWER_ANIM_SETTINGS))
				v4(DrawerPanelStatus.Scrollable)
			end

			ref.current = nil
			ref2.current = nil
			return
		end

		ref.current = nil
		ref2.current = nil
	end, FFlagEnableDrawerAnimatingHook and { v12, fn2 } or {})

	local v15 = React.useCallback(function(p)
		if not ref3.current or (ref.current == nil or v3:getValue() == DrawerPanelStatus.Closing) then
			return
		end

		local v15 = p.Position.X - ref.current.X

		if v3:getValue() == DrawerPanelStatus.Static then
			local v16 = p.Position.Y - ref.current.Y

			if math.abs(v15) > math.abs(v16) then
				v4(DrawerPanelStatus.Movable)
			else
				v4(DrawerPanelStatus.Scrollable)
			end
		end

		if v3:getValue() == DrawerPanelStatus.Movable and v15 < 0 then
			v7((ReactOtter.instant(v15)))
		end

		if p.Position.X > ref.current.X then
			ref.current = p.Position
		end
	end, {})

	React.useEffect(function()
		local getDrawerVisible = GetDrawerVisibleStore(false).getDrawerVisible
		return Signals.createEffect(function(p)
			local drawerVisible = getDrawerVisible(p)
			ref3.current = drawerVisible

			local v16 = drawerVisible and 0 or -ref4.current

			if FFlagEnableDrawerAnimatingHook then
				fn2(true)
			end

			v7(ReactOtter.ease(v16, Constants.DRAWER_ANIM_SETTINGS))

			if not FFlagSideSheetOpenPeoplePage then
				local v17 = not drawerVisible and 1 or Constants.SCRIM_TRANSPARENCY
				v9(ReactOtter.ease(v17, Constants.DRAWER_ANIM_SETTINGS))
			end
		end)
	end, FFlagEnableDrawerAnimatingHook and { fn2 } or {})

	if FFlagSideSheetOpenPeoplePage then
		React.useEffect(function()
			local getDrawerVisible = GetDrawerVisibleStore(false).getDrawerVisible
			return Signals.createEffect(function(p)
				local v16 = (not getDrawerVisible(p) or clipsDescendants) and 1 or Constants.SCRIM_TRANSPARENCY

				v9(ReactOtter.ease(v16, Constants.DRAWER_ANIM_SETTINGS))
			end)
		end, { clipsDescendants })
	end

	React.useEffect(function()
		if FFlagSideSheetOpenPeoplePage and not ref3.current and menuPosX:getValue() ~= -current2 then
			v7((ReactOtter.instant(-current2)))
		end
	end, { current2 })

	React.useEffect(function()
		local touchStartedConnection = UserInputService.TouchStarted:Connect(v13)
		local touchEndedConnection = UserInputService.TouchEnded:Connect(v14)
		local touchMovedConnection = UserInputService.TouchMoved:Connect(v15)
		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()
			touchMovedConnection:Disconnect()
		end
	end, FFlagSideSheetOpenPeoplePage and { v14, v15, v13 } or {})

	local onActivated = React.useCallback(function()
		if v3:getValue() == DrawerPanelStatus.Closing then
			return
		end

		if v3:getValue() ~= DrawerPanelStatus.Movable then
			v12("shield")
		end
	end, { v3, v12 })
	local visible

	if FFlagSideSheetOpenPeoplePage then
		visible = React.useMemo(function()
			return React.joinBindings({ menuPosX = menuPosX, scrimTransparency = v8 }):map(function(p): boolean
				return p.menuPosX > -current2 or p.scrimTransparency < 1
			end)
		end, { current2 })
	else
		visible = v8:map(function(p): boolean
			return p < 1
		end)
	end

	local v16 = {
		DrawerContent = React.createElement("ScrollingFrame", {
			ref = ref5,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Selectable = false,
			Size = UDim2.new(0, props.menuWidth, 1, -topOffset - bottomOffset),
			Position = UDim2.new(0, leftOffset, 0, topOffset),
			CanvasSize = UDim2.new(0, props.menuWidth, 0, 0),
			Active = v5,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ClipsDescendants = true,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = v5,
			ZIndex = 2
		}, props.children),
		DeviceSafeInsetsBackground = 0,
		SinkInput = 0
	}
	local deviceSafeInsetsBackground

	if deviceSafeInsets then
		deviceSafeInsetsBackground = React.createElement(Foundation.View, {
			Position = UDim2.fromOffset(-deviceSafeInsets.left, -deviceSafeInsets.top),
			Size = UDim2.new(1, deviceSafeInsets.left, 1, deviceSafeInsets.top + deviceSafeInsets.bottom),
			backgroundStyle = props.backgroundStyle,
			ZIndex = 0
		})
	end

	v16.DeviceSafeInsetsBackground = deviceSafeInsetsBackground

	local createElement = React.createElement
	local position

	if deviceSafeInsets then
		position = UDim2.fromOffset(-deviceSafeInsets.left, -deviceSafeInsets.top)
	end

	local size

	if deviceSafeInsets then
		size = UDim2.new(1, deviceSafeInsets.left, 1, deviceSafeInsets.top + deviceSafeInsets.bottom)
	else
		size = UDim2.fromScale(1, 1)
	end

	v16.SinkInput = createElement("ImageButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = position,
		Size = size,
		Selectable = false,
		AutoButtonColor = false,
		ZIndex = zIndex
	})

	local customEventHandlers = React.useMemo(function()
		if not FFlagEnableDrawerFocusNav then
			return {}
		end

		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					if FFlagFixDrawerNavigateBackWhileClosing then
						if v3:getValue() ~= DrawerPanelStatus.Closing then
							v12("focus-navigation-back")
						end
					else
						v12("focus-navigation-back")
					end

					object:cancel()
				end)
			}
		}
	end, { v12 })

	local createElement2 = React.createElement
	local view = Foundation.View
	local v17 = {
		testId = FFlagSideSheetOpenPeoplePage and "drawer-root" or nil,
		Size = 0,
		ClipsDescendants = 0,
		backgroundStyle = 0,
		Visible = 0
	}
	local size2

	if clipsDescendants then
		size2 = UDim2.new(0, current2, 1, 0)
	else
		size2 = UDim2.fromScale(1, 1)
	end

	v17.Size = size2
	v17.ClipsDescendants = clipsDescendants
	v17.backgroundStyle = { Transparency = 1 }

	v17.Visible = visible
	local scrim

	if not clipsDescendants then
		if deviceSafeInsets then
			scrim = React.createElement(Foundation.View, {
				Position = UDim2.fromOffset(-deviceSafeInsets.left, -deviceSafeInsets.top),
				Size = UDim2.new(
					1,
					deviceSafeInsets.left + deviceSafeInsets.right,
					1,
					deviceSafeInsets.top + deviceSafeInsets.bottom
				),
				backgroundStyle = { Transparency = 1 },
				ZIndex = 1
			}, {
				Scrim = React.createElement(Scrim, {
					onActivated = onActivated,
					transparencyBinding = v8,
					zIndex = 1,
					isModal = props.scrimIsModal
				})
			})
		else
			scrim = React.createElement(Scrim, {
				onActivated = onActivated,
				transparencyBinding = v8,
				zIndex = 1,
				isModal = props.scrimIsModal
			})
		end
	end

	local drawerAnimatedFrame

	if FFlagEnableDrawerFocusNav then
		local createElement3 = React.createElement
		local v18 = {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.Drawer,
			frameProps = 0,
			isIsolated = true,
			customEventHandlers = 0
		}
		local frameProps = {
			Position = menuPosX:map(function(p)
				return UDim2.fromOffset(p, 0)
			end),
			ZIndex = 2,
			Size = UDim2.new(0, current2, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = backgroundColor,
			BackgroundTransparency = backgroundTransparency,
			Selectable = false,
			SelectionBehaviorRight = 0
		}
		local selectionBehaviorRight

		if clipsDescendants then
			selectionBehaviorRight = Enum.SelectionBehavior.Escape
		end

		frameProps.SelectionBehaviorRight = selectionBehaviorRight
		v18.frameProps = frameProps

		v18.customEventHandlers = customEventHandlers
		drawerAnimatedFrame = createElement3(focusNavigableSurfaceWrapper, v18, v16)
	else
		drawerAnimatedFrame = React.createElement(Foundation.View, {
			Position = menuPosX:map(function(p)
				return UDim2.fromOffset(p, 0)
			end),
			ZIndex = 2,
			Size = UDim2.new(0, current2, 1, 0),
			BorderSizePixel = 0,
			backgroundStyle = props.backgroundStyle,
			Selectable = false
		}, v16)
	end

	return createElement2(view, v17, { Scrim = scrim, DrawerAnimatedFrame = drawerAnimatedFrame })
end

return React.memo(fn)
