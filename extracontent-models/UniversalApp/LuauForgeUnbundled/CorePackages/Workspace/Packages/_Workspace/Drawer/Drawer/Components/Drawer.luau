local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/React")
local ReactIs = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/ReactIs")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Foundation")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/ReactOtter")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Signals")
local GetDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Stores/GetDrawerVisibleStore")
local useSetDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Hooks/useSetDrawerVisible")
local useSetDrawerShouldMount = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Hooks/useSetDrawerShouldMount")
local useSetDrawerAnimating = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Hooks/useSetDrawerAnimating")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Components/Scrim")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Types")
local drawerPanelStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Enum").DrawerPanelStatus

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/SharedFlags")
local fFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local fFlagEnableDrawerAnimatingHook = SharedFlags.FFlagEnableDrawerAnimatingHook
local fFlagSideSheetOpenPeoplePage = SharedFlags.FFlagSideSheetOpenPeoplePage
local fFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets
local fFlagFixDrawerNavigateBackWhileClosing = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Flags").FFlagFixDrawerNavigateBackWhileClosing
local focusNavigableSurfaceWrapper, focusNavigableSurfaceIdentifierEnum, focusNavigationEventNameEnum, v5

if fFlagEnableDrawerFocusNav then
	local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/FocusNavigationUtils")
	focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
	focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
	focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/InputHandlers")
else
	focusNavigationEventNameEnum = nil
	v5 = nil
	focusNavigableSurfaceWrapper = nil
	focusNavigableSurfaceIdentifierEnum = nil
end

local function fn(props)
	local v6 = useSetDrawerVisible()
	local v7 = useSetDrawerShouldMount()

	local fn2 = not fFlagEnableDrawerAnimatingHook and function(p2) end or useSetDrawerAnimating()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v8, v9 = React.useBinding(drawerPanelStatus.Scrollable)
	local v10 = React.useMemo(function()
		return v8:map(function(p2): boolean
			return p2 == drawerPanelStatus.Scrollable
		end)
	end, {})

	local v11 = React.useMemo(function()
		return v8:map(function(p2): number
			if p2 == drawerPanelStatus.Movable then
				return 3
			end

			return 1
		end)
	end, {})
	local v12

	if fFlagEnableDrawerFocusNav then
		v12 = React.useMemo(function()
			local backgroundStyle = props.backgroundStyle

			if backgroundStyle == nil then
				return nil
			end

			if ReactIs.isBinding(backgroundStyle) then
				return backgroundStyle:map(function(p2)
					return p2.Color3
				end)
			end

			return backgroundStyle.Color3
		end, { props.backgroundStyle })
	end

	local v13

	if fFlagEnableDrawerFocusNav then
		v13 = React.useMemo(function()
			local backgroundStyle = props.backgroundStyle

			if backgroundStyle == nil then
				return nil
			end

			if ReactIs.isBinding(backgroundStyle) then
				return backgroundStyle:map(function(p2)
					return p2.Transparency
				end)
			end

			return backgroundStyle.Transparency
		end, { props.backgroundStyle })
	end

	local topOffset = props.topOffset or 0
	local bottomOffset = props.bottomOffset or 0
	local leftOffset = props.leftOffset or 0
	local deviceSafeInsets = if fFlagFixOverlayTopInsetForDeviceSafeInsets then props.deviceSafeInsets else nil
	local v14 = fFlagSideSheetOpenPeoplePage and props.allowOutsideInteraction == true
	local v15 = props.menuWidth + leftOffset
	local ref3 = React.useRef(false)
	local v16 = React.useCallback(function(p2)
		if fFlagEnableDrawerAnimatingHook then
			fn2(false)
		end

		if v8:getValue() == drawerPanelStatus.Closing then
			v9(drawerPanelStatus.Scrollable)
		end

		if p2 == -v15 then
			v7(false)
		end
	end, (fFlagSideSheetOpenPeoplePage or fFlagEnableDrawerAnimatingHook) and { v15, fn2, v7 } or {})

	local v17, v18 = ReactOtter.useAnimatedBinding(-v15, v16)

	local ref4 = React.useRef(v15)
	ref4.current = v15

	local ref5 = React.useRef(nil)
	local v19, v20 = ReactOtter.useAnimatedBinding(1)
	local v21

	if fFlagSideSheetOpenPeoplePage then
		v21 = React.useCallback(function(p2): boolean
			local current = ref5.current

			if current == nil then
				return false
			end

			local position = p2.Position
			local absolutePosition = current.AbsolutePosition
			local absoluteSize = current.AbsoluteSize
			return position.X >= absolutePosition.X
				and position.X <= absolutePosition.X + absoluteSize.X
				and position.Y >= absolutePosition.Y
				and position.Y <= absolutePosition.Y + absoluteSize.Y
		end, {})
	else
		v21 = nil
	end

	local useCallback = React.useCallback
	local function fn3(p2)
		v6(false)
		v9(drawerPanelStatus.Closing)

		if props.onDrawerClosedAnalytics then
			props.onDrawerClosedAnalytics({ source = p2 })
		end
	end

	local v22

	if fFlagSideSheetOpenPeoplePage then
		v22 = { props.onDrawerClosedAnalytics, v6 }
	else
		v22 = { props.onDrawerClosedAnalytics }
	end

	local v23 = useCallback(fn3, v22)

	local v24 = React.useCallback(function(p2)
		if not ref3.current or v8:getValue() == drawerPanelStatus.Closing or v14 and not v21(p2) then
			return
		end

		ref.current = p2.Position
		ref2.current = DateTime.now().UnixTimestampMillis
		v9(drawerPanelStatus.Static)
	end, fFlagSideSheetOpenPeoplePage and { v14, v21 } or {})

	local v25 = React.useCallback(function(p2)
		if
			ref3.current
			and ref.current ~= nil
			and ref2.current ~= nil
			and v8:getValue() == drawerPanelStatus.Movable
		then
			local v26 = ref.current.X - p2.Position.X

			if ref4.current * Constants.DRAWER_SWIPE_THRESHOLD_PERCENT <= v26 then
				v23("swipe")
			elseif v26 > 0 then
				local v27 = (DateTime.now().UnixTimestampMillis - ref2.current) / 1000

				if v27 > 0.01 and v26 / v27 >= Constants.DRAWER_VELOCITY_THRESHOLD then
					v23("swipe")
				end
			end

			if v8:getValue() ~= drawerPanelStatus.Closing then
				if fFlagEnableDrawerAnimatingHook then
					fn2(true)
				end

				v18(ReactOtter.ease(0, Constants.DRAWER_ANIM_SETTINGS))
				v9(drawerPanelStatus.Scrollable)
			end

			ref.current = nil
			ref2.current = nil
			return
		end

		ref.current = nil
		ref2.current = nil
	end, fFlagEnableDrawerAnimatingHook and { v23, fn2 } or {})

	local v26 = React.useCallback(function(p2)
		if not ref3.current or (ref.current == nil or v8:getValue() == drawerPanelStatus.Closing) then
			return
		end

		local v27 = p2.Position.X - ref.current.X

		if v8:getValue() == drawerPanelStatus.Static then
			local v28 = p2.Position.Y - ref.current.Y

			if math.abs(v27) > math.abs(v28) then
				v9(drawerPanelStatus.Movable)
			else
				v9(drawerPanelStatus.Scrollable)
			end
		end

		if v8:getValue() == drawerPanelStatus.Movable and v27 < 0 then
			v18(ReactOtter.instant(v27))
		end

		if p2.Position.X > ref.current.X then
			ref.current = p2.Position
		end
	end, {})

	React.useEffect(function()
		local getDrawerVisible = GetDrawerVisibleStore(false).getDrawerVisible
		return Signals.createEffect(function(p2)
			local drawerVisible = getDrawerVisible(p2)
			ref3.current = drawerVisible

			local v27 = drawerVisible and 0 or -ref4.current

			if fFlagEnableDrawerAnimatingHook then
				fn2(true)
			end

			v18(ReactOtter.ease(v27, Constants.DRAWER_ANIM_SETTINGS))

			if not fFlagSideSheetOpenPeoplePage then
				local v28 = not drawerVisible and 1 or Constants.SCRIM_TRANSPARENCY
				v20(ReactOtter.ease(v28, Constants.DRAWER_ANIM_SETTINGS))
			end
		end)
	end, fFlagEnableDrawerAnimatingHook and { fn2 } or {})

	if fFlagSideSheetOpenPeoplePage then
		React.useEffect(function()
			local getDrawerVisible = GetDrawerVisibleStore(false).getDrawerVisible
			return Signals.createEffect(function(p2)
				local v27 = (not getDrawerVisible(p2) or v14) and 1 or Constants.SCRIM_TRANSPARENCY

				v20(ReactOtter.ease(v27, Constants.DRAWER_ANIM_SETTINGS))
			end)
		end, { v14 })
	end

	React.useEffect(function()
		if fFlagSideSheetOpenPeoplePage and not ref3.current and v17:getValue() ~= -v15 then
			v18(ReactOtter.instant(-v15))
		end
	end, { v15 })

	React.useEffect(function()
		local touchStartedConnection = UserInputService.TouchStarted:Connect(v24)
		local touchEndedConnection = UserInputService.TouchEnded:Connect(v25)
		local touchMovedConnection = UserInputService.TouchMoved:Connect(v26)
		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()
			touchMovedConnection:Disconnect()
		end
	end, fFlagSideSheetOpenPeoplePage and { v25, v26, v24 } or {})

	local v27 = React.useCallback(function()
		if v8:getValue() == drawerPanelStatus.Closing then
			return
		end

		if v8:getValue() ~= drawerPanelStatus.Movable then
			v23("shield")
		end
	end, { v8, v23 })
	local v28

	if fFlagSideSheetOpenPeoplePage then
		v28 = React.useMemo(function()
			return React.joinBindings({ menuPosX = v17, scrimTransparency = v19 }):map(function(p2): boolean
				return p2.menuPosX > -v15 or p2.scrimTransparency < 1
			end)
		end, { v15 })
	else
		v28 = v19:map(function(p2): boolean
			return p2 < 1
		end)
	end

	local v29 = {
		DrawerContent = React.createElement("ScrollingFrame", {
			ref = ref5,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Selectable = false,
			Size = UDim2.new(0, props.menuWidth, 1, -topOffset - bottomOffset),
			Position = UDim2.new(0, leftOffset, 0, topOffset),
			CanvasSize = UDim2.new(0, props.menuWidth, 0, 0),
			Active = v10,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ClipsDescendants = true,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = v10,
			ZIndex = 2
		}, props.children),
		DeviceSafeInsetsBackground = 0,
		SinkInput = 0
	}

	local v30 = if deviceSafeInsets then React.createElement(Foundation.View, {
		Position = UDim2.fromOffset(-deviceSafeInsets.left, -deviceSafeInsets.top),
		Size = UDim2.new(1, deviceSafeInsets.left, 1, deviceSafeInsets.top + deviceSafeInsets.bottom),
		backgroundStyle = props.backgroundStyle,
		ZIndex = 0
	}) else nil
	v29.DeviceSafeInsetsBackground = v30

	local createElement = React.createElement

	local v33 = if deviceSafeInsets then UDim2.fromOffset(-deviceSafeInsets.left, -deviceSafeInsets.top) else nil

	local v34 = if deviceSafeInsets then UDim2.new(
		1,
		deviceSafeInsets.left,
		1,
		deviceSafeInsets.top + deviceSafeInsets.bottom
	) else UDim2.fromScale(1, 1)
	v29.SinkInput = createElement("ImageButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = v33,
		Size = v34,
		Selectable = false,
		AutoButtonColor = false,
		ZIndex = v11
	})

	local v35 = React.useMemo(function()
		if not fFlagEnableDrawerFocusNav then
			return {}
		end

		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = v5.onRelease(function(object)
					if fFlagFixDrawerNavigateBackWhileClosing then
						if v8:getValue() ~= drawerPanelStatus.Closing then
							v23("focus-navigation-back")
						end
					else
						v23("focus-navigation-back")
					end

					object:cancel()
				end)
			}
		}
	end, { v23 })

	local createElement2 = React.createElement
	local view = Foundation.View
	local v36 = {
		testId = fFlagSideSheetOpenPeoplePage and "drawer-root" or nil,
		Size = 0,
		ClipsDescendants = 0,
		backgroundStyle = 0,
		Visible = 0
	}

	local v37 = if v14 then UDim2.new(0, v15, 1, 0) else UDim2.fromScale(1, 1)
	v36.Size = v37
	v36.ClipsDescendants = v14
	v36.backgroundStyle = { Transparency = 1 }

	v36.Visible = v28
	local v39

	if not v14 then
		if deviceSafeInsets then
			v39 = React.createElement(Foundation.View, {
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
				Scrim = React.createElement(module10, {
					onActivated = v27,
					transparencyBinding = v19,
					zIndex = 1,
					isModal = props.scrimIsModal
				})
			})
		else
			v39 = React.createElement(module10, {
				onActivated = v27,
				transparencyBinding = v19,
				zIndex = 1,
				isModal = props.scrimIsModal
			})
		end
	end

	local v40

	if fFlagEnableDrawerFocusNav then
		local createElement3 = React.createElement
		local v42 = {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.Drawer,
			frameProps = 0,
			isIsolated = true,
			customEventHandlers = 0
		}
		local v43 = {
			Position = v17:map(function(p2)
				return UDim2.fromOffset(p2, 0)
			end),
			ZIndex = 2,
			Size = UDim2.new(0, v15, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = v12,
			BackgroundTransparency = v13,
			Selectable = false,
			SelectionBehaviorRight = 0
		}

		local v44 = if v14 then Enum.SelectionBehavior.Escape else nil
		v43.SelectionBehaviorRight = v44
		v42.frameProps = v43

		v42.customEventHandlers = v35
		v40 = createElement3(focusNavigableSurfaceWrapper, v42, v29)
	else
		v40 = React.createElement(Foundation.View, {
			Position = v17:map(function(p2)
				return UDim2.fromOffset(p2, 0)
			end),
			ZIndex = 2,
			Size = UDim2.new(0, v15, 1, 0),
			BorderSizePixel = 0,
			backgroundStyle = props.backgroundStyle,
			Selectable = false
		}, v29)
	end

	return createElement2(view, v36, { Scrim = v39, DrawerAnimatedFrame = v40 })
end

return React.memo(fn)
