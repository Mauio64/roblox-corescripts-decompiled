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
local Scrim = require(script.Parent.Scrim)
local Constants = require(script.Parent.Parent.Constants)

require(script.Parent.Parent.Types)

local DrawerPanelStatus = require(script.Parent.Parent.Enum).DrawerPanelStatus
local FocusNavigableSurfaceWrapper = nil
local FocusNavigableSurfaceIdentifierEnum = nil
local FocusNavigationEventNameEnum = nil
local InputHandlers = nil
local FFlagEnableDrawerFocusNav = require(DrawerParent.SharedFlags).FFlagEnableDrawerFocusNav

if FFlagEnableDrawerFocusNav then
	local FocusNavigationUtils = require(DrawerParent.FocusNavigationUtils)

	FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
	FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
	FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
	InputHandlers = require(DrawerParent.InputHandlers)
end

return React.memo(function(p1) -- line: 37
	-- upvalues: useSetDrawerVisible (copy), useSetDrawerShouldMount (copy), React (copy), DrawerPanelStatus (copy), FFlagEnableDrawerFocusNav (copy), ReactIs (copy), ReactOtter (copy), Constants (copy), GetDrawerVisibleStore (copy), Signals (copy), UserInputService (copy), FocusNavigationEventNameEnum (ref), InputHandlers (ref), Foundation (copy), Scrim (copy), FocusNavigableSurfaceWrapper (ref), FocusNavigableSurfaceIdentifierEnum (ref)
	local v22 = useSetDrawerVisible()
	local v23 = useSetDrawerShouldMount()
	local v24 = React.useRef(nil)
	local v25 = React.useRef(nil)
	local v26, v27 = React.useBinding(DrawerPanelStatus.Scrollable)
	local v28 = React.useMemo(function() -- line: 43
		-- upvalues: v26 (copy), DrawerPanelStatus (copy)
		return v26:map(function(p2) -- line: 44
			-- upvalues: DrawerPanelStatus (copy)
			return p2 == DrawerPanelStatus.Scrollable
		end)
	end, {})
	local v29 = React.useMemo(function() -- line: 49
		-- upvalues: v26 (copy), DrawerPanelStatus (copy)
		return v26:map(function(p3) -- line: 50
			-- upvalues: DrawerPanelStatus (copy)
			if p3 == DrawerPanelStatus.Movable then
				return 3
			end

			return 1
		end)
	end, {})
	local v30 = if not FFlagEnableDrawerFocusNav then nil else React.useMemo(function() -- line: 62
		-- upvalues: p1 (copy), ReactIs (copy)
		local backgroundStyle = p1.backgroundStyle

		if backgroundStyle == nil then
			return nil
		end

		if ReactIs.isBinding(backgroundStyle) then
			return backgroundStyle:map(function(p4) -- line: 68
				return p4.Color3
			end)
		end

		return backgroundStyle.Color3
	end, { p1.backgroundStyle })
	local v31 = if not FFlagEnableDrawerFocusNav then nil else React.useMemo(function() -- line: 77
		-- upvalues: p1 (copy), ReactIs (copy)
		local backgroundStyle = p1.backgroundStyle

		if backgroundStyle == nil then
			return nil
		end

		if ReactIs.isBinding(backgroundStyle) then
			return backgroundStyle:map(function(p5) -- line: 83
				return p5.Transparency
			end)
		end

		return backgroundStyle.Transparency
	end, { p1.backgroundStyle })
	local v32 = p1.topOffset or 0
	local v33 = p1.bottomOffset or 0
	local v34 = p1.leftOffset or 0
	local v35 = p1.menuWidth + v34
	local v36 = React.useCallback(function(p6) -- line: 95
		-- upvalues: v26 (copy), DrawerPanelStatus (copy), v27 (copy), v35 (copy), v23 (copy)
		if v26:getValue() == DrawerPanelStatus.Closing then
			v27(DrawerPanelStatus.Scrollable)
		end

		if p6 == -v35 then
			v23(false)
		end
	end, {})
	local v37, v38 = ReactOtter.useAnimatedBinding(-v35, v36)
	local v39 = React.useRef(v35)

	v39.current = v35

	local v40 = React.useRef(false)
	local v41, v42 = ReactOtter.useAnimatedBinding(1)
	local v43 = React.useCallback(function(p7) -- line: 111
		-- upvalues: v22 (copy), v27 (copy), DrawerPanelStatus (copy), p1 (copy)
		v22(false)
		v27(DrawerPanelStatus.Closing)

		if p1.onDrawerClosedAnalytics then
			p1.onDrawerClosedAnalytics({
				source = p7
			})
		end
	end, { p1.onDrawerClosedAnalytics })
	local v44 = React.useCallback(function(p8) -- line: 119
		-- upvalues: v40 (copy), v26 (copy), DrawerPanelStatus (copy), v24 (copy), v25 (copy), v27 (copy)
		if not v40.current then
			return
		end

		if v26:getValue() == DrawerPanelStatus.Closing then
			return
		end

		v24.current = p8.Position
		v25.current = DateTime.now().UnixTimestampMillis
		v27(DrawerPanelStatus.Static)
	end, {})
	local v45 = React.useCallback(function(p9) -- line: 131
		-- upvalues: v40 (copy), v24 (copy), v25 (copy), v26 (copy), DrawerPanelStatus (copy), v39 (copy), Constants (copy), v43 (copy), v38 (copy), ReactOtter (copy), v27 (copy)
		if not v40.current then
			v24.current = nil
			v25.current = nil

			return
		end

		if v24.current == nil or v25.current == nil or v26:getValue() ~= DrawerPanelStatus.Movable then
			v24.current = nil
			v25.current = nil

			return
		end

		local v57 = v24.current.X - p9.Position.X

		if v57 >= v39.current * Constants.DRAWER_SWIPE_THRESHOLD_PERCENT then
			v43("swipe")
		elseif v57 > 0 then
			local v58 = (DateTime.now().UnixTimestampMillis - v25.current) / 1000

			if v58 > 0.01 and v57 / v58 >= Constants.DRAWER_VELOCITY_THRESHOLD then
				v43("swipe")
			end
		end

		if v26:getValue() ~= DrawerPanelStatus.Closing then
			v38(ReactOtter.ease(0, Constants.DRAWER_ANIM_SETTINGS))
			v27(DrawerPanelStatus.Scrollable)
		end

		v24.current = nil
		v25.current = nil
	end, {})
	local v46 = React.useCallback(function(p10) -- line: 169
		-- upvalues: v40 (copy), v24 (copy), v26 (copy), DrawerPanelStatus (copy), v27 (copy), v38 (copy), ReactOtter (copy)
		if not v40.current then
			return
		end

		if v24.current == nil or v26:getValue() == DrawerPanelStatus.Closing then
			return
		end

		local v60 = p10.Position.X - v24.current.X

		if v26:getValue() == DrawerPanelStatus.Static then
			local v61 = p10.Position.Y - v24.current.Y

			if math.abs(v60) > math.abs(v61) then
				v27(DrawerPanelStatus.Movable)
			else
				v27(DrawerPanelStatus.Scrollable)
			end
		end

		if v26:getValue() == DrawerPanelStatus.Movable and v60 < 0 then
			v38((ReactOtter.instant(v60)))
		end

		if p10.Position.X > v24.current.X then
			v24.current = p10.Position
		end
	end, {})

	React.useEffect(function() -- line: 196
		-- upvalues: GetDrawerVisibleStore (copy), Signals (copy), v40 (copy), v39 (copy), v38 (copy), ReactOtter (copy), Constants (copy), v42 (copy)
		local getDrawerVisible = GetDrawerVisibleStore(false).getDrawerVisible

		return Signals.createEffect(function(p11) -- line: 198
			-- upvalues: getDrawerVisible (copy), v40 (copy), v39 (copy), v38 (copy), ReactOtter (copy), Constants (copy), v42 (copy)
			local v74 = getDrawerVisible(p11)

			v40.current = v74

			local v75 = if not v74 then -v39.current else 0

			v38(ReactOtter.ease(v75, Constants.DRAWER_ANIM_SETTINGS))

			local v76 = not v74 and 1 or Constants.SCRIM_TRANSPARENCY

			v42(ReactOtter.ease(v76, Constants.DRAWER_ANIM_SETTINGS))
		end)
	end, {})
	React.useEffect(function() -- line: 210
		-- upvalues: UserInputService (copy), v44 (copy), v45 (copy), v46 (copy)
		local connection = UserInputService.TouchStarted:Connect(v44)
		local connection2 = UserInputService.TouchEnded:Connect(v45)
		local connection3 = UserInputService.TouchMoved:Connect(v46)

		return function() -- line: 214
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {})

	local v47 = React.useCallback(function() -- line: 221
		-- upvalues: v26 (copy), DrawerPanelStatus (copy), v43 (copy)
		if v26:getValue() == DrawerPanelStatus.Closing then
			return
		end

		if v26:getValue() ~= DrawerPanelStatus.Movable then
			v43("shield")
		end
	end, {
		v26,
		v43
	})
	local v48 = v41:map(function(p12) -- line: 232
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
			Size = UDim2.new(0, p1.menuWidth, 1, -v32 - v33),
			Position = UDim2.new(0, v34, 0, v32),
			CanvasSize = UDim2.new(0, p1.menuWidth, 0, 0),
			Active = v28,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = v28
		}, p1.children),
		SinkInput = React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			AutoButtonColor = false,
			Size = UDim2.fromScale(1, 1),
			ZIndex = v29
		})
	}
	local v50 = React.useMemo(function() -- line: 262
		-- upvalues: FFlagEnableDrawerFocusNav (copy), FocusNavigationEventNameEnum (ref), InputHandlers (ref), v43 (copy)
		if not FFlagEnableDrawerFocusNav then
			return {}
		end

		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p13) -- line: 268
					-- upvalues: v43 (copy)
					v43("focus-navigation-back")
					p13:cancel()
				end)
			}
		}
	end, { v43 })

	return React.createElement(Foundation.View, {
		Size = UDim2.fromScale(1, 1),
		backgroundStyle = {
			Transparency = 1
		},
		Visible = v48
	}, {
		Scrim = React.createElement(Scrim, {
			zIndex = 1,
			onActivated = v47,
			transparencyBinding = v41,
			isModal = p1.scrimIsModal
		}),
		DrawerAnimatedFrame = if not FFlagEnableDrawerFocusNav then React.createElement(Foundation.View, {
			ZIndex = 2,
			BorderSizePixel = 0,
			Selectable = false,
			Position = v37:map(function(p14) -- line: 307
				return UDim2.fromOffset(p14, 0)
			end),
			Size = UDim2.new(0, v35, 1, 0),
			backgroundStyle = p1.backgroundStyle
		}, t1) else React.createElement(FocusNavigableSurfaceWrapper, {
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.Drawer,
			frameProps = {
				ZIndex = 2,
				BorderSizePixel = 0,
				Selectable = false,
				Position = v37:map(function(p15) -- line: 293
					return UDim2.fromOffset(p15, 0)
				end),
				Size = UDim2.new(0, v35, 1, 0),
				BackgroundColor3 = v30,
				BackgroundTransparency = v31
			},
			customEventHandlers = v50
		}, t1)
	})
end)
