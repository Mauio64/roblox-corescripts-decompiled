local Drawer = script:FindFirstAncestor("Drawer")
local UserInputService = game:GetService("UserInputService")
local DrawerParent = Drawer.Parent
local React = require(DrawerParent.React)
local ReactIs = require(DrawerParent.ReactIs)
local Foundation = require(DrawerParent.Foundation)
local ReactOtter = require(DrawerParent.ReactOtter)
local Signals = require(DrawerParent.Signals)
local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)
local useSetDrawerVisible = require(script.Parent.Parent.Hooks.useSetDrawerVisible)
local useSetDrawerShouldMount = require(script.Parent.Parent.Hooks.useSetDrawerShouldMount)
local useSetDrawerAnimating = require(script.Parent.Parent.Hooks.useSetDrawerAnimating)
local Scrim = require(script.Parent.Scrim)
local Constants = require(script.Parent.Parent.Constants)

require(script.Parent.Parent.Types)

local DrawerPanelStatus = require(script.Parent.Parent.Enum).DrawerPanelStatus
local FocusNavigableSurfaceWrapper = nil
local FocusNavigableSurfaceIdentifierEnum = nil
local FocusNavigationEventNameEnum = nil
local InputHandlers = nil
local FFlagEnableDrawerFocusNav = require(DrawerParent.SharedFlags).FFlagEnableDrawerFocusNav
local FFlagEnableDrawerAnimatingHook = require(Drawer.Flags).FFlagEnableDrawerAnimatingHook

if FFlagEnableDrawerFocusNav then
	local FocusNavigationUtils = require(DrawerParent.FocusNavigationUtils)

	FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
	FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
	FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
	InputHandlers = require(DrawerParent.InputHandlers)
end

return React.memo(function(p1) -- line: 39
	-- upvalues: useSetDrawerVisible (copy), useSetDrawerShouldMount (copy), FFlagEnableDrawerAnimatingHook (copy), useSetDrawerAnimating (copy), React (copy), DrawerPanelStatus (copy), FFlagEnableDrawerFocusNav (copy), ReactIs (copy), ReactOtter (copy), Constants (copy), GetDrawerVisibleStore (copy), Signals (copy), UserInputService (copy), FocusNavigationEventNameEnum (ref), InputHandlers (ref), Foundation (copy), Scrim (copy), FocusNavigableSurfaceWrapper (ref), FocusNavigableSurfaceIdentifierEnum (ref)
	local v24 = useSetDrawerVisible()
	local v25 = useSetDrawerShouldMount()
	local v26 = not FFlagEnableDrawerAnimatingHook and function(_: boolean) -- line: 44
	end or useSetDrawerAnimating()
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)
	local v29, v30 = React.useBinding(DrawerPanelStatus.Scrollable)
	local v31 = React.useMemo(function() -- line: 48
		-- upvalues: v29 (copy), DrawerPanelStatus (copy)
		return v29:map(function(p2) -- line: 49
			-- upvalues: DrawerPanelStatus (copy)
			return p2 == DrawerPanelStatus.Scrollable
		end)
	end, {})
	local v32 = React.useMemo(function() -- line: 54
		-- upvalues: v29 (copy), DrawerPanelStatus (copy)
		return v29:map(function(p3) -- line: 55
			-- upvalues: DrawerPanelStatus (copy)
			if p3 == DrawerPanelStatus.Movable then
				return 3
			end

			return 1
		end)
	end, {})
	local v33 = if not FFlagEnableDrawerFocusNav then nil else React.useMemo(function() -- line: 67
		-- upvalues: p1 (copy), ReactIs (copy)
		local backgroundStyle = p1.backgroundStyle

		if backgroundStyle == nil then
			return nil
		end

		if ReactIs.isBinding(backgroundStyle) then
			return backgroundStyle:map(function(p4) -- line: 73
				return p4.Color3
			end)
		end

		return backgroundStyle.Color3
	end, { p1.backgroundStyle })
	local v34 = if not FFlagEnableDrawerFocusNav then nil else React.useMemo(function() -- line: 82
		-- upvalues: p1 (copy), ReactIs (copy)
		local backgroundStyle = p1.backgroundStyle

		if backgroundStyle == nil then
			return nil
		end

		if ReactIs.isBinding(backgroundStyle) then
			return backgroundStyle:map(function(p5) -- line: 88
				return p5.Transparency
			end)
		end

		return backgroundStyle.Transparency
	end, { p1.backgroundStyle })
	local v35 = p1.topOffset or 0
	local v36 = p1.bottomOffset or 0
	local v37 = p1.leftOffset or 0
	local v38 = p1.menuWidth + v37
	local v39 = React.useCallback(function(p6) -- line: 101
		-- upvalues: FFlagEnableDrawerAnimatingHook (copy), v26 (copy), v29 (copy), DrawerPanelStatus (copy), v30 (copy), v38 (copy), v25 (copy)
		if FFlagEnableDrawerAnimatingHook then
			v26(false)
		end

		if v29:getValue() == DrawerPanelStatus.Closing then
			v30(DrawerPanelStatus.Scrollable)
		end

		if p6 == -v38 then
			v25(false)
		end
	end, if not FFlagEnableDrawerAnimatingHook then {} else {
		v38,
		v26,
		v25
	})
	local v40, v41 = ReactOtter.useAnimatedBinding(-v38, v39)
	local v42 = React.useRef(v38)

	v42.current = v38

	local v43 = React.useRef(false)
	local v44, v45 = ReactOtter.useAnimatedBinding(1)
	local v46 = React.useCallback(function(p7) -- line: 124
		-- upvalues: v24 (copy), v30 (copy), DrawerPanelStatus (copy), p1 (copy)
		v24(false)
		v30(DrawerPanelStatus.Closing)

		if p1.onDrawerClosedAnalytics then
			p1.onDrawerClosedAnalytics({
				source = p7
			})
		end
	end, { p1.onDrawerClosedAnalytics })
	local v47 = React.useCallback(function(p8) -- line: 132
		-- upvalues: v43 (copy), v29 (copy), DrawerPanelStatus (copy), v27 (copy), v28 (copy), v30 (copy)
		if not v43.current then
			return
		end

		if v29:getValue() == DrawerPanelStatus.Closing then
			return
		end

		v27.current = p8.Position
		v28.current = DateTime.now().UnixTimestampMillis
		v30(DrawerPanelStatus.Static)
	end, {})
	local v48 = React.useCallback(function(p9) -- line: 144
		-- upvalues: v43 (copy), v27 (copy), v28 (copy), v29 (copy), DrawerPanelStatus (copy), v42 (copy), Constants (copy), v46 (copy), FFlagEnableDrawerAnimatingHook (copy), v26 (copy), v41 (copy), ReactOtter (copy), v30 (copy)
		if not v43.current then
			v27.current = nil
			v28.current = nil

			return
		end

		if v27.current == nil or v28.current == nil or v29:getValue() ~= DrawerPanelStatus.Movable then
			v27.current = nil
			v28.current = nil

			return
		end

		local v61 = v27.current.X - p9.Position.X

		if v61 >= v42.current * Constants.DRAWER_SWIPE_THRESHOLD_PERCENT then
			v46("swipe")
		elseif v61 > 0 then
			local v62 = (DateTime.now().UnixTimestampMillis - v28.current) / 1000

			if v62 > 0.01 and v61 / v62 >= Constants.DRAWER_VELOCITY_THRESHOLD then
				v46("swipe")
			end
		end

		if v29:getValue() ~= DrawerPanelStatus.Closing then
			if FFlagEnableDrawerAnimatingHook then
				v26(true)
			end

			v41(ReactOtter.ease(0, Constants.DRAWER_ANIM_SETTINGS))
			v30(DrawerPanelStatus.Scrollable)
		end

		v27.current = nil
		v28.current = nil
	end, if not FFlagEnableDrawerAnimatingHook then {} else {
		v46,
		v26
	})
	local v49 = React.useCallback(function(p10) -- line: 185
		-- upvalues: v43 (copy), v27 (copy), v29 (copy), DrawerPanelStatus (copy), v30 (copy), v41 (copy), ReactOtter (copy)
		if not v43.current then
			return
		end

		if v27.current == nil or v29:getValue() == DrawerPanelStatus.Closing then
			return
		end

		local v64 = p10.Position.X - v27.current.X

		if v29:getValue() == DrawerPanelStatus.Static then
			local v65 = p10.Position.Y - v27.current.Y

			if math.abs(v64) > math.abs(v65) then
				v30(DrawerPanelStatus.Movable)
			else
				v30(DrawerPanelStatus.Scrollable)
			end
		end

		if v29:getValue() == DrawerPanelStatus.Movable and v64 < 0 then
			v41((ReactOtter.instant(v64)))
		end

		if p10.Position.X > v27.current.X then
			v27.current = p10.Position
		end
	end, {})

	React.useEffect(function() -- line: 212
		-- upvalues: GetDrawerVisibleStore (copy), Signals (copy), v43 (copy), v42 (copy), FFlagEnableDrawerAnimatingHook (copy), v26 (copy), v41 (copy), ReactOtter (copy), Constants (copy), v45 (copy)
		local getDrawerVisible = GetDrawerVisibleStore(false).getDrawerVisible

		return Signals.createEffect(function(p11) -- line: 214
			-- upvalues: getDrawerVisible (copy), v43 (copy), v42 (copy), FFlagEnableDrawerAnimatingHook (copy), v26 (copy), v41 (copy), ReactOtter (copy), Constants (copy), v45 (copy)
			local v78 = getDrawerVisible(p11)

			v43.current = v78

			local v79 = if not v78 then -v42.current else 0

			if FFlagEnableDrawerAnimatingHook then
				v26(true)
			end

			v41(ReactOtter.ease(v79, Constants.DRAWER_ANIM_SETTINGS))

			local v80 = not v78 and 1 or Constants.SCRIM_TRANSPARENCY

			v45(ReactOtter.ease(v80, Constants.DRAWER_ANIM_SETTINGS))
		end)
	end, if not FFlagEnableDrawerAnimatingHook then {} else { v26 })
	React.useEffect(function() -- line: 229
		-- upvalues: UserInputService (copy), v47 (copy), v48 (copy), v49 (copy)
		local connection = UserInputService.TouchStarted:Connect(v47)
		local connection2 = UserInputService.TouchEnded:Connect(v48)
		local connection3 = UserInputService.TouchMoved:Connect(v49)

		return function() -- line: 233
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {})

	local v50 = React.useCallback(function() -- line: 240
		-- upvalues: v29 (copy), DrawerPanelStatus (copy), v46 (copy)
		if v29:getValue() == DrawerPanelStatus.Closing then
			return
		end

		if v29:getValue() ~= DrawerPanelStatus.Movable then
			v46("shield")
		end
	end, {
		v29,
		v46
	})
	local v51 = v44:map(function(p12) -- line: 251
		return p12 < 1
	end)
	local t1 = {
		DrawerContent = React.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			Selectable = false,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ClipsDescendants = true,
			ZIndex = 2,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(0, p1.menuWidth, 1, -v35 - v36),
			Position = UDim2.new(0, v37, 0, v35),
			CanvasSize = UDim2.new(0, p1.menuWidth, 0, 0),
			Active = v31,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = v31
		}, p1.children),
		SinkInput = React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			AutoButtonColor = false,
			Size = UDim2.fromScale(1, 1),
			ZIndex = v32
		})
	}
	local v53 = React.useMemo(function() -- line: 281
		-- upvalues: FFlagEnableDrawerFocusNav (copy), FocusNavigationEventNameEnum (ref), InputHandlers (ref), v46 (copy)
		if not FFlagEnableDrawerFocusNav then
			return {}
		end

		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p13) -- line: 287
					-- upvalues: v46 (copy)
					v46("focus-navigation-back")
					p13:cancel()
				end)
			}
		}
	end, { v46 })

	return React.createElement(Foundation.View, {
		Size = UDim2.fromScale(1, 1),
		backgroundStyle = {
			Transparency = 1
		},
		Visible = v51
	}, {
		Scrim = React.createElement(Scrim, {
			zIndex = 1,
			onActivated = v50,
			transparencyBinding = v44,
			isModal = p1.scrimIsModal
		}),
		DrawerAnimatedFrame = if not FFlagEnableDrawerFocusNav then React.createElement(Foundation.View, {
			ZIndex = 2,
			BorderSizePixel = 0,
			Selectable = false,
			Position = v40:map(function(p14) -- line: 326
				return UDim2.fromOffset(p14, 0)
			end),
			Size = UDim2.new(0, v38, 1, 0),
			backgroundStyle = p1.backgroundStyle
		}, t1) else React.createElement(FocusNavigableSurfaceWrapper, {
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.Drawer,
			frameProps = {
				ZIndex = 2,
				BorderSizePixel = 0,
				Selectable = false,
				Position = v40:map(function(p15) -- line: 312
					return UDim2.fromOffset(p15, 0)
				end),
				Size = UDim2.new(0, v38, 1, 0),
				BackgroundColor3 = v33,
				BackgroundTransparency = v34
			},
			customEventHandlers = v53
		}, t1)
	})
end)
