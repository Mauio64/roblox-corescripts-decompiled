local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local useProperties = ReactUtils.useProperties
local useForwardRef = ReactUtils.useForwardRef
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local RoactRodux = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local t1 = {
	dampingRatio = 1,
	frequency = 3,
	restingPositionLimit = 0.1,
	restingVelocityLimit = 2
}

local function useJoinBindings(p1: ((...any) -> ...any), t2: {[any]: any}) -- line: 52
	-- upvalues: React (copy), Dash (copy)
	return React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t2 (copy), React (copy), p1 (copy)
		local v96 = Dash.map(t2, function(p2) -- line: 55
			-- upvalues: React (copy)
			if type(p2) == "table" and p2.getValue then
				return p2
			end

			return React.createBinding(p2)
		end)

		return React.joinBindings(v96):map(function(p3) -- line: 62
			-- upvalues: p1 (copy)
			return p1(unpack(p3))
		end)
	end, t2)
end
local function useBackEvent(p4, p5: ((...any) -> ...any)?) -- line: 68
	-- upvalues: React (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy)
	local v22 = React.useCallback(function(p6) -- line: 69
		-- upvalues: p5 (copy)
		if p6.eventData and (p6.eventData.UserInputState == Enum.UserInputState.End and p5) then
			p6.cancelled = true
			p5()
		end
	end, { p5 })

	return (ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v22, nil, p4))
end
local function useFocusState(p7) -- line: 87
	-- upvalues: ReactFocusNavigation (copy), React (copy), ReactOtter (copy), useForwardRef (copy), t1 (copy)
	local v24 = ReactFocusNavigation.useFocusedGuiObject()
	local v25 = ReactFocusNavigation.useFocusGuiObject()
	local v26 = React.useRef(nil)
	local v27 = React.useRef(nil)
	local v28 = React.useCallback(function(p8) -- line: 96
		-- upvalues: v26 (copy), v27 (copy)
		if p8 == 1 and v26.current then
			v26.current()
			v26.current = nil
		end

		if p8 == 0 and v27.current then
			v27.current()
			v27.current = nil
		end
	end, {})
	local v29, v30 = ReactOtter.useAnimatedBinding(0, v28)
	local v31, v32 = React.useState(false)
	local v33 = React.useRef(nil)
	local v34 = React.useCallback(function(p9) -- line: 111
		-- upvalues: v33 (copy), v26 (copy), v25 (copy), v27 (copy), v32 (copy), v24 (copy)
		function v33.current() -- line: 112
			-- upvalues: v26 (copy), v25 (copy), p9 (copy), v27 (copy), v32 (copy), v24 (copy)
			function v26.current() -- line: 113
				-- upvalues: v25 (copy), p9 (copy)
				v25(p9)
			end
			function v27.current() -- line: 116
				-- upvalues: v32 (copy), v25 (copy), v24 (copy)
				v32(false)
				v25(v24)
			end
		end
	end, {
		v24,
		v25
	})

	return useForwardRef(p7, v34), v31, v29, React.useCallback(function() -- line: 123
		-- upvalues: v29 (copy), v33 (copy), v32 (copy), v30 (copy), ReactOtter (copy), t1 (copy)
		if v29:getValue() == 0 and v33.current then
			v33.current()
			v32(true)
			v30(ReactOtter.spring(1, t1))
		end
	end, {
		v24,
		v29
	}), (React.useCallback(function() -- line: 131
		-- upvalues: v29 (copy), v30 (copy), ReactOtter (copy), t1 (copy)
		if v29:getValue() == 1 then
			v30(ReactOtter.spring(0, t1))
		end
	end, { v29 }))
end

return React.forwardRef(function(t3: {[any]: any}, p10) -- line: 140
	-- upvalues: useSelectionCursor (copy), CursorKind (copy), RoactRodux (copy), React (copy), useProperties (copy), useFocusState (copy), useBackEvent (copy), Dash (copy)
	local v37 = useSelectionCursor(CursorKind.RoundedRect)
	local v38 = t3.selectionCursor or v37
	local v39 = RoactRodux.useSelector(function(p11) -- line: 144
		return p11.ScreenSize or Vector2.zero
	end)
	local v40 = React.useMemo(function() -- line: 148
		-- upvalues: t3 (copy), v39 (copy)
		if t3.safeAreaSize then
			return Vector2.new(v39.X * t3.safeAreaSize.X.Scale + t3.safeAreaSize.X.Offset, v39.Y * t3.safeAreaSize.Y.Scale + t3.safeAreaSize.Y.Offset)
		end

		return v39
	end, {
		v39,
		t3.safeAreaSize
	})
	local v41, v42 = React.useBinding(Vector2.zero)
	local v43 = useProperties(p10, v42, "AbsolutePosition")
	local v44, v45 = React.useBinding(Vector2.zero)
	local v46 = useProperties(nil, v45, "AbsoluteSize")
	local _, v48 = React.useBinding(Vector2.zero)
	local v49 = useProperties(nil, v48, "AbsolutePosition")
	local v50, v51 = React.useBinding(Vector2.zero)
	local v52 = useProperties(nil, v51, "AbsoluteSize")
	local v53, v54, v55, v56, v57 = useFocusState(v43)
	local u58 = v54
	local v59 = useBackEvent(v53, if not u58 then nil else v57)
	local v60, v61 = React.useState(false)
	local v62 = React.useMemo(function() -- line: 183
		-- upvalues: t3 (copy), Dash (copy), u58 (ref)
		return (t3.renderHeader or Dash.noop)(u58)
	end, {
		u58,
		t3.renderHeader
	})
	local v63 = React.useMemo(function() -- line: 188
		-- upvalues: t3 (copy), u58 (ref)
		return t3.renderContents(u58)
	end, {
		u58,
		t3.renderContents
	})
	local v64, v65 = React.useMemo(function() -- line: 192
		-- upvalues: React (copy), v52 (copy), v63 (copy), t3 (copy), v60 (copy), u58 (ref)
		local v101 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Selectable = false,
			SelectionGroup = true,
			Position = UDim2.new(),
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ref = v52,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		}, v63)
		local v102, v103 = t3.renderContentWrapper(v60, u58, v101)

		return v102, v103 or {}
	end, {
		v63,
		v60,
		v52,
		t3.renderContentWrapper
	})

	local function v66(vector2: Vector2, vector2_2: Vector2, t4: {[any]: any}, _: boolean, _: Vector2) -- line: 214
		local v109 = t4.top or 0
		local v110 = t4.bottom or 0
		local v111 = vector2.Y + v109 + vector2_2.Y + v110

		return UDim2.new(1, 0, 0, v111)
	end

	local t5 = {
		v44,
		v50,
		v65,
		t3.limitInlineHeight,
		v40
	}
	local v68 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t5 (copy), React (copy), v66 (copy)
		local v112 = Dash.map(t5, function(p12) -- line: 55
			-- upvalues: React (copy)
			if type(p12) == "table" and p12.getValue then
				return p12
			end

			return React.createBinding(p12)
		end)

		return React.joinBindings(v112):map(function(p13) -- line: 62
			-- upvalues: v66 (copy)
			return v66(unpack(p13))
		end)
	end, t5)

	local function v69(n1: number, n2: number) -- line: 229
		if n1 > 0 then
			return 1000000
		end

		return n2
	end

	local t6 = {
		v55,
		t3.zIndex
	}
	local v71 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t6 (copy), React (copy), v69 (copy)
		local v115 = Dash.map(t6, function(p14) -- line: 55
			-- upvalues: React (copy)
			if type(p14) == "table" and p14.getValue then
				return p14
			end

			return React.createBinding(p14)
		end)

		return React.joinBindings(v115):map(function(p15) -- line: 62
			-- upvalues: v69 (copy)
			return v69(unpack(p15))
		end)
	end, t6)

	local function v72(n3: number, vector2: Vector2) -- line: 233
		if n3 > 0 then
			return UDim2.fromOffset(-vector2.X, -vector2.Y - 200)
		end

		return UDim2.new()
	end

	local t7 = {
		v55,
		v41
	}
	local v74 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t7 (copy), React (copy), v72 (copy)
		local v118 = Dash.map(t7, function(p16) -- line: 55
			-- upvalues: React (copy)
			if type(p16) == "table" and p16.getValue then
				return p16
			end

			return React.createBinding(p16)
		end)

		return React.joinBindings(v118):map(function(p17) -- line: 62
			-- upvalues: v72 (copy)
			return v72(unpack(p17))
		end)
	end, t7)

	local function v75(n4: number, vector2: Vector2) -- line: 241
		if n4 > 0 then
			return UDim2.fromOffset(vector2.X, vector2.Y + 400)
		end

		return UDim2.new()
	end

	local t8 = {
		v55,
		v39
	}
	local v77 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t8 (copy), React (copy), v75 (copy)
		local v121 = Dash.map(t8, function(p18) -- line: 55
			-- upvalues: React (copy)
			if type(p18) == "table" and p18.getValue then
				return p18
			end

			return React.createBinding(p18)
		end)

		return React.joinBindings(v121):map(function(p19) -- line: 62
			-- upvalues: v75 (copy)
			return v75(unpack(p19))
		end)
	end, t8)

	local function v78(n5: number, n6: number) -- line: 249
		return 1 - n5 * (1 - n6)
	end

	local t9 = {
		v55,
		t3.overlayTransparency or 1
	}
	local v80 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t9 (copy), React (copy), v78 (copy)
		local v124 = Dash.map(t9, function(p20) -- line: 55
			-- upvalues: React (copy)
			if type(p20) == "table" and p20.getValue then
				return p20
			end

			return React.createBinding(p20)
		end)

		return React.joinBindings(v124):map(function(p21) -- line: 62
			-- upvalues: v78 (copy)
			return v78(unpack(p21))
		end)
	end, t9)

	local function v81(n7: number, uDim2: UDim2, vector2: Vector2) -- line: 255
		-- upvalues: t3 (copy), v61 (copy)
		local YOffset = uDim2.Y.Offset
		local v129 = math.min(YOffset, vector2.Y) - YOffset
		local v130 = not t3.limitInlineHeight and 0 or v129

		v61(v129 < 0 and n7 == 1)

		return UDim2.new(1, 0, 0, YOffset + n7 * v129 + (1 - n7) * v130)
	end

	local t10 = {
		v55,
		v68,
		v40,
		v60,
		v61
	}
	local v83 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t10 (copy), React (copy), v81 (copy)
		local v131 = Dash.map(t10, function(p22) -- line: 55
			-- upvalues: React (copy)
			if type(p22) == "table" and p22.getValue then
				return p22
			end

			return React.createBinding(p22)
		end)

		return React.joinBindings(v131):map(function(p23) -- line: 62
			-- upvalues: v81 (copy)
			return v81(unpack(p23))
		end)
	end, t10)

	local function v84(n8: number, vector2: Vector2, uDim2: UDim2, vector2_3: Vector2) -- line: 267
		local v136 = (vector2_3.Y - uDim2.Y.Offset) / 2 - vector2.Y

		return UDim2.fromOffset(0, n8 * v136)
	end

	local t11 = {
		v55,
		v41,
		v83,
		v39
	}
	local v86 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t11 (copy), React (copy), v84 (copy)
		local v137 = Dash.map(t11, function(p24) -- line: 55
			-- upvalues: React (copy)
			if type(p24) == "table" and p24.getValue then
				return p24
			end

			return React.createBinding(p24)
		end)

		return React.joinBindings(v137):map(function(p25) -- line: 62
			-- upvalues: v84 (copy)
			return v84(unpack(p25))
		end)
	end, t11)

	local function v87(uDim2: UDim2, vector2: Vector2) -- line: 280
		return uDim2 + UDim2.fromOffset(0, vector2.Y)
	end

	local t12 = {
		v86,
		v44
	}
	local v89 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t12 (copy), React (copy), v87 (copy)
		local v140 = Dash.map(t12, function(p26) -- line: 55
			-- upvalues: React (copy)
			if type(p26) == "table" and p26.getValue then
				return p26
			end

			return React.createBinding(p26)
		end)

		return React.joinBindings(v140):map(function(p27) -- line: 62
			-- upvalues: v87 (copy)
			return v87(unpack(p27))
		end)
	end, t12)

	local function v90(uDim2: UDim2, vector2: Vector2) -- line: 284
		return uDim2 - UDim2.fromOffset(0, vector2.Y)
	end

	local t13 = {
		v83,
		v44
	}
	local v92 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t13 (copy), React (copy), v90 (copy)
		local v143 = Dash.map(t13, function(p28) -- line: 55
			-- upvalues: React (copy)
			if type(p28) == "table" and p28.getValue then
				return p28
			end

			return React.createBinding(p28)
		end)

		return React.joinBindings(v143):map(function(p29) -- line: 62
			-- upvalues: v90 (copy)
			return v90(unpack(p29))
		end)
	end, t13)

	local function v93(n9: number) -- line: 292
		if n9 < 1 then
			return 4
		end

		return 2
	end

	local t14 = { v55 }
	local v95 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), t14 (copy), React (copy), v93 (copy)
		local v145 = Dash.map(t14, function(p30) -- line: 55
			-- upvalues: React (copy)
			if type(p30) == "table" and p30.getValue then
				return p30
			end

			return React.createBinding(p30)
		end)

		return React.joinBindings(v145):map(function(p31) -- line: 62
			-- upvalues: v93 (copy)
			return v93(unpack(p31))
		end)
	end, t14)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Selectable = false,
		Size = if not t3.limitInlineHeight then v68 else v83,
		ref = v59,
		LayoutOrder = t3.layoutOrder,
		ZIndex = v71
	}, {
		Overlay = React.createElement("TextButton", {
			Text = "",
			Position = v74,
			Size = v77,
			BackgroundColor3 = t3.overlayColor3 or Color3.new(0, 0, 0),
			BackgroundTransparency = v80,
			AutoButtonColor = false,
			ZIndex = 1,
			Selectable = false,
			Active = true,
			[React.Event.Activated] = v57
		}),
		Header = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Selectable = false,
			ZIndex = 3,
			ref = v46,
			Position = v86,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, v62),
		Panel = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			ZIndex = 3,
			Position = v89,
			Size = v92,
			ref = v49
		}, v64),
		Cover = React.createElement("TextButton", {
			Text = "",
			Position = v89,
			Size = v92,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			ZIndex = v95,
			Active = true,
			Selectable = true,
			SelectionImageObject = v38,
			SelectionOrder = 1,
			SelectionGroup = u58,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			[React.Event.Activated] = v56
		})
	})
end)
