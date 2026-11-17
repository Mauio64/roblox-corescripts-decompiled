local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local Otter = require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local ReactRoblox = require(parent.ReactRoblox)
local ReactUtils = require(parent.ReactUtils)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local useElevation = require(Foundation.Providers.Elevation.useElevation)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local ElevationProvider = require(Foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope
local ElevationLayer = require(Foundation.Enums.ElevationLayer)

local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)

local SheetContext = require(script.Parent.SheetContext)
local Types = require(script.Parent.Types)

local SheetType = require(script.Parent.SheetType)

local childrenHasFullBleed = require(script.Parent.childrenHasFullBleed)
local useHardwareInsets = require(script.Parent.useHardwareInsets)
local useScreenHeight = require(script.Parent.useScreenHeight)

local Backdrop = require(Foundation.Components.Backdrop)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)

local usePreferences = require(Foundation.Providers.Preferences.usePreferences)

local v = { defaultSnapPointIndex = 1, testId = "--foundation-sheet" }

local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function advanceCriticalDampedSpring(y: number, current: number, p: number, dt: number) -- 1 equivalent call inferred from this helper
	local v2 = y - p
	local v3 = 25.132741228718345 * dt
	local v4 = math.exp(-v3)
	local v5 = current + 25.132741228718345 * v2

	local v6 = (v2 + v5 * dt) * v4
	local v7 = (current - v5 * v3) * v4

	return p + v6, v7
end

local function BottomSheet(p, p2)
	local v2 = withDefaults(p, v)
	local v3 = useOverlay()
	local v4 = useTokens()
	local owner = useElevation(ElevationLayer.Sheet, { stackAboveOwner = false })

	local reducedMotion = usePreferences().reducedMotion

	local v5 = useScreenHeight()

	local state, setState = React.useState(not v3 and 0 or v3.AbsoluteSize.Y)
	local state2, setState2 = React.useState(0)
	local v6 = React.useMemo(function()
		return { state2 }
	end, { state2 })
	local snapPoints = v2.snapPoints or v6

	local v7 = React.useCallback(function(p3: number)
		if p3 > 1 then
			return p3
		end

		return p3 * v5
	end, { v5 })
	local v8 = 0
	local minValue = 1e999

	for _, snapPoint in snapPoints do
		local v9 = v7(snapPoint)

		if v8 < v9 then
			v8 = v9
		end

		if Flags.FoundationSheetReversedContent then
			minValue = math.min(minValue, v9)
		end
	end

	local v9 = math.min(v8, v5)

	if state > 0 then
		v9 = math.min(v9, state)
	end

	if Flags.FoundationSheetReversedContent then
		minValue = math.min(minValue, v9)
	end

	local bottom = useHardwareInsets(v3).bottom

	local ref = React.useRef(0)
	local ref2 = React.useRef(false)

	local ref3 = React.useRef(v2.onSnapPointChanged)
	ref3.current = v2.onSnapPointChanged

	local transparency, v10 = useAnimatedBinding(1, function()
		if ref2.current then
			v2.onClose()
		end
	end)
	local sheetHeightAvailable, setSheetHeightAvailable = React.useBinding(-bottom)
	local actionsHeight, setActionsHeight = React.useBinding(0)
	local hasActionsDivider, setHasActionsDivider = React.useBinding(false)
	local hasHeader, setHasHeader = React.useBinding(false)

	local hasFullBleed = childrenHasFullBleed(v2.children)
	local fullBleedHeight, setFullBleedHeight = React.useBinding(0)

	local ref4 = React.useRef(0)
	local ref5 = React.useRef(nil)
	local innerScrollY, v11 = React.useBinding(0)
	local ref6 = React.useRef(nil)
	local innerScrollingEnabled, v12 = React.useBinding(false)
	local ref7

	if Flags.FoundationSheetReversedContent then
		ref7 = React.useRef(false)
	else
		ref7 = nil
	end

	local setIsContentReversed

	if Flags.FoundationSheetReversedContent then
		setIsContentReversed = React.useCallback(function(current: boolean)
			ref7.current = current
		end, {})
	else
		setIsContentReversed = nil
	end

	local contentRevealOffset

	if Flags.FoundationSheetReversedContent then
		contentRevealOffset = React.useMemo(function()
			if v2.snapPoints == nil then
				return nil
			end

			return sheetHeightAvailable:map(function(p3: number)
				local v13 = p3 + v4.Margin.Small
				return v9 - math.clamp(v13, minValue, v9)
			end)
		end, {
			v2.snapPoints == nil,
			sheetHeightAvailable,
			minValue,
			v9,
			v4.Margin.Small
		})
	else
		contentRevealOffset = nil
	end

	local ref8 = React.useRef(false)
	local ref9 = React.useRef(0)
	local ref10 = React.useRef(nil)
	local ref11 = React.useRef(false)
	local ref12 = React.useRef(0)

	local ref13 = React.useRef(false)
	local state3, setState3 = React.useState(false)
	local v13 = React.useCallback(function(current: boolean)
		if ref13.current == current then
			return
		end

		ref13.current = current
		setState3(current)
	end, {})

	local v14 = React.useCallback(function()
		if ref10.current then
			ref10.current:Disconnect()
			ref10.current = nil
		end

		ref9.current = 0
		ref11.current = false
	end, {})

	local v15 = React.useCallback(function(p3: number)
		v14()
		ref11.current = true

		if ref5.current then
			ref5.current:ResetScrollVelocity()
		end

		local RunService = game:GetService("RunService")
		ref10.current = RunService.Heartbeat:Connect(function(dt)
			if not (ref5.current and ref11.current) then
				v14()
				return
			end

			local v15, current = advanceCriticalDampedSpring(ref5.current.CanvasPosition.Y, ref12.current, p3, dt) -- inferred equivalent call

			ref12.current = current
			ref5.current.CanvasPosition = Vector2.new(0, v15)
			local v16

			if math.abs(p3 - ref5.current.CanvasPosition.Y) < 0.5 then
				v16 = math.abs(ref12.current) < 1
			else
				v16 = false
			end

			if v16 then
				ref5.current.CanvasPosition = Vector2.new(0, p3)
				v14()
			end
		end)
	end, { v14 })

	local v16 = React.useCallback(function(p3: number)
		return math.min(v7(p3), v9) + bottom
	end, { bottom, v7, v9 })

	local v17 = React.useCallback(function(current: number)
		ref.current = current
		v15(v16(snapPoints[current]))

		if ref3.current then
			ref3.current(snapPoints[current], current)
		end
	end, { v16, snapPoints })

	local v18 = React.useCallback(function(current: number)
		v14()
		ref.current = current

		if ref5.current then
			ref5.current.CanvasPosition = Vector2.new(0, v16(snapPoints[current]))
		end

		if ref3.current then
			ref3.current(snapPoints[current], current)
		end
	end, { v14, v16, snapPoints })

	local v19 = React.useCallback(function(flag: boolean?)
		if ref2.current then
			return
		end

		if reducedMotion and not flag then
			ref2.current = true
			v14()

			if ref5.current then
				ref5.current.CanvasPosition = Vector2.new(0, 0)
			end

			v10((Otter.instant(1)))
		else
			ref12.current = -ref9.current
			v15(0)
			v10(Otter.ease(1, { duration = v4.Time.Time_100 }))

			ref2.current = true
		end
	end, { v15, v14, reducedMotion })

	local v20 = React.useCallback(function(): boolean
		local v20 = math.floor(v9 + bottom)
		local current = ref4.current
		return v20 - 0.01 <= current
	end, { v9, bottom })

	local v21 = React.useCallback(function()
		local v21 = innerScrollY:getValue() <= 0
		local v22 = v20()

		if Flags.FoundationSheetReversedContent and ref7.current then
			if ref8.current and not (innerScrollingEnabled:getValue() or v22) then
				return
			end

			local current = ref6.current
			local v23 = current == nil
				or innerScrollY:getValue() >= current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y - 1
			local current2 = ref9.current
			local v24 = ref8.current

			if v24 then
				if current2 > 0 and v21 then
					v24 = v21
				elseif current2 < 0 then
					v24 = v23 and not v22
				else
					v24 = false
				end
			end

			v12(not v24)
		elseif not v22 and ref9.current < 0 or ref9.current > 0 and v21 and ref8.current then
			v12(false)
		elseif (ref9.current < 0 or ref9.current == 0) and v22 then
			v12(true)
		end
	end, { v20 })

	local v22 = React.useCallback(function()
		local current = ref9.current
		local v22 = ref4.current - current / 2.35

		local v23 = {
			{ index = 0, position = 0 }
		}

		for k, snapPoint in snapPoints do
			table.insert(v23, { index = k, position = v16(snapPoint) })
		end

		table.sort(v23, function(a, b): boolean
			return math.abs(a.position - v22) < math.abs(b.position - v22)
		end)

		local v24 = v23[1]

		if not ref8.current then
			ref12.current = -current

			if v24.index == 0 then
				v19(true)
			else
				v17(v24.index)
			end
		end
	end, { snapPoints, v17, v16, v19 })
	local v23

	if Flags.FoundationBottomSheetKeepsSnapPoint then
		v23 = React.useCallback(function()
			local snapPoint = snapPoints[ref.current]

			if snapPoint ~= nil and not (v9 <= v7(snapPoint)) then
				local current = 1

				for k, snapPoint2 in snapPoints do
					if v7(snapPoint2) > v7(snapPoints[current]) then
						current = k
					end
				end

				ref.current = current

				if ref3.current then
					ref3.current(snapPoints[current], current)
				end
			end
		end, { snapPoints, v7, v9 })
	else
		v23 = nil
	end

	React.useEffect(function()
		if v3 then
			local v24

			if Flags.FoundationBottomSheetKeepsSnapPoint and snapPoints[ref.current] ~= nil then
				v24 = ref.current
			else
				v24 = v2.defaultSnapPointIndex
			end

			if reducedMotion then
				v18(v24)
				v10(Otter.instant(0))
			else
				v17(v24)
				v10(Otter.ease(0, { duration = v4.Time.Time_100 }))
			end

			local v25 = v9 <= v7(snapPoints[v24])

			if Flags.FoundationSheetReversedContent and not v25 then
				v25 = ref7.current
			end

			v12(v25)
		end

		return function()
			v14()
		end
	end, { v3, snapPoints, v2.defaultSnapPointIndex, v17, v7, v18, reducedMotion })

	React.useLayoutEffect(function()
		if not v3 then
			return
		end

		setState(v3.AbsoluteSize.Y)
		local absoluteSizeChangedConnection = v3:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			setState(v3.AbsoluteSize.Y)
		end)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { v3 })

	React.useEffect(function()
		local UserInputService = game:GetService("UserInputService")
		local touchPanConnection = UserInputService.TouchPan:Connect(function(_, p3, p4, _)
			ref9.current = p4.Y

			if ref8.current and p3 and math.abs(p3.Y) > math.abs(p3.X) then
				v13(true)
			end

			v21()
		end)
		local UserInputService2 = game:GetService("UserInputService")
		local inputBeganConnection = UserInputService2.InputBegan:Connect(function()
			ref8.current = true
			ref9.current = 0
			v13(false)
			v14()
		end)
		local UserInputService3 = game:GetService("UserInputService")
		local inputEndedConnection = UserInputService3.InputEnded:Connect(function()
			if ref8.current == false then
				return
			end

			ref8.current = false
			v13(false)
			ref9.current = not ref5.current and 0 or ref5.current:GetScrollVelocity().Y

			if Flags.FoundationSheetReversedContent and ref7.current then
				v12(true)
			end

			if not (v20() or ref2.current) then
				v22()
				return
			end

			v12(true)

			if Flags.FoundationBottomSheetKeepsSnapPoint and not ref2.current then
				v23()
			end
		end)

		return function()
			v13(false)
			touchPanConnection:Disconnect()
			inputBeganConnection:Disconnect()
			inputEndedConnection:Disconnect()
		end
	end, { v3, v22, v21, v14, v20, v13, v23 })

	local ref14 = React.useRef(nil)
	local state4, setState4 = React.useState(nil)

	local state5, setState5 = React.useState(nil)
	local ref15 = ReactUtils.useComposedRef(p2, setState5)

	React.useImperativeHandle(v2.sheetRef, function()
		return { close = v19 }
	end, {})

	local v24 = React.useMemo(function()
		return {
			actionsHeight = actionsHeight,
			setActionsHeight = setActionsHeight,
			hasActionsDivider = hasActionsDivider,
			setHasActionsDivider = setHasActionsDivider,
			sheetHeightAvailable = sheetHeightAvailable,
			setSheetHeightAvailable = setSheetHeightAvailable,
			safeAreaPadding = bottom,
			bottomPadding = 200,
			innerScrollingEnabled = innerScrollingEnabled,
			innerScrollY = innerScrollY,
			innerScrollingRef = ref6,
			setInnerScrollY = function(p3: number)
				v11(p3)
				v21()
			end,
			hasHeader = hasHeader,
			setHasHeader = setHasHeader,
			hasFullBleed = hasFullBleed,
			fullBleedHeight = fullBleedHeight,
			setFullBleedHeight = setFullBleedHeight,
			closeSheet = v19,
			hasRadius = true,
			sheetType = SheetType.Bottom,
			innerSurface = state5,
			testId = v2.testId,
			closeAffordanceRef = ref14,
			contentStartRef = state4,
			setContentStartRef = setState4,
			isVerticalSheetGesture = state3,
			contentRevealOffset = contentRevealOffset,
			setIsContentReversed = setIsContentReversed
		}
	end, {
		v2.testId,
		v19,
		bottom,
		v21,
		state5,
		ref14,
		state4,
		hasFullBleed,
		state3,
		contentRevealOffset,
		setIsContentReversed
	})

	local createElement = React.createElement
	local v25 = {
		ZIndex = 5,
		backgroundStyle = v4.Color.Content.Muted,
		Position = 0,
		AnchorPoint = 0,
		tag = "align-y-center size-1000-100 padding-y-small radius-small",
		testId = 0
	}
	local v26

	if hasFullBleed then
		v26 = v4.Padding.Small
	else
		v26 = -v4.Padding.XSmall
	end

	v25.Position = UDim2.new(0.5, 0, 0, v26)
	v25.AnchorPoint = Vector2.new(0.5, 0)

	v25.testId = `{v2.testId}--gripper`
	local element = createElement(View, v25, {
		TouchTarget = React.createElement(View, {
			tag = "size-1000-600",
			stateLayer = { affordance = StateLayerAffordance.None },
			onActivated = function()
				ref8.current = false

				if Flags.FoundationSheetReversedContent and ref7.current and ref6.current then
					local current = ref6.current

					local v27 = math.max(0, current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y)
					v11(v27)
					current.CanvasPosition = Vector2.new(0, v27)
					current:ResetScrollVelocity()
				elseif ref6.current then
					v11(0)
					ref6.current.CanvasPosition = Vector2.new(0, 0)
					ref6.current:ResetScrollVelocity()
				end

				if not (#snapPoints > 1) then
					v19()

					return
				end

				local v27 = ref.current % #snapPoints + 1

				if reducedMotion then
					v18(v27)
				else
					v17(v27)
				end

				local v28 = v9 <= v7(snapPoints[v27])

				if Flags.FoundationSheetReversedContent and not v28 then
					v28 = ref7.current
				end

				v12(v28)
			end
		})
	})

	if v3 then
		local createPortal = ReactRoblox.createPortal
		local createElement2 = React.createElement

		local v27 = {
			ZIndex = owner.zIndex,
			ref = ref15,
			selection = Types.nonSelectable,
			selectionGroup = Types.isolatedSelectionGroup,
			tag = "size-full",
			testId = `{v2.testId}--surface`
		}

		local createElement3 = React.createElement
		local v28 = {
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(1, 0, 1, v9 + bottom),
			ClipsDescendants = false,
			BackgroundTransparency = 1,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarThickness = 0,
			ref = ref5,
			[React.Change.CanvasPosition] = function(p3)
				ref4.current = p3.CanvasPosition.Y
				local v28

				if Flags.FoundationSheetReversedContent and contentRevealOffset then
					v28 = contentRevealOffset:getValue()
				end

				setSheetHeightAvailable(ref4.current - bottom - v4.Margin.Small)

				if Flags.FoundationSheetReversedContent and contentRevealOffset and v28 then
					local current = ref6.current
					local v29 = contentRevealOffset:getValue() - v28

					if ref7.current and current and v29 ~= 0 then
						current.CanvasPosition = Vector2.new(0, current.CanvasPosition.Y + v29)
					end
				end

				v21()

				if ref4.current <= 0 then
					v19()
				end
			end
		}

		local createElement4 = React.createElement
		local v29 = {
			Size = UDim2.new(1, 0, 1, 200 - v9 - bottom),
			Position = UDim2.new(0, 0, 1, -v9),
			ZIndex = 3
		}

		local createElement5 = React.createElement
		local size

		if v2.snapPoints == nil then
			size = UDim2.fromScale(1, 0)
		else
			size = UDim2.new(1, 0, 0, v9 + 200)
		end

		local automaticSize

		if v2.snapPoints == nil then
			automaticSize = Enum.AutomaticSize.Y
		end

		local v30 = {
			SheetContainer = createElement4(View, v29, {
				Sheet = createElement5(View, {
					Size = size,
					AutomaticSize = automaticSize,
					onAbsoluteSizeChanged = v2.snapPoints == nil and function(p3)
						setState2(p3.AbsoluteSize.Y - 200)
					end or nil,
					stateLayer = { affordance = StateLayerAffordance.None },
					onActivated = Dash.noop,
					testId = v2.testId,
					tag = {
						["col items-center radius-large clip bg-surface-100"] = true,
						["padding-top-medium"] = not hasFullBleed
					}
				}, {
					GripperContainer = React.createElement("Folder", nil, { Gripper = element }),
					Content = React.createElement(
						SheetContext.Provider,
						{ value = v24 },
						React.createElement(ElevationOwnerScope, { owner = owner }, v2.children)
					)
				})
			}),
			Shadow = 0,
			Backdrop = 0
		}
		local shadow

		if Flags.FoundationBottomSheetOverlayShadow then
			shadow = React.createElement(View, {
				tag = "shadow-overlay-300 radius-large",
				Size = UDim2.new(1, 0, 0, v9 + 200),
				Position = UDim2.new(0, 0, 1, -v9),
				ZIndex = 2,
				testId = `{v2.testId}--shadow`
			})
		else
			shadow = React.createElement(Image, {
				Image = SHADOW_IMAGE,
				Size = UDim2.new(1, SHADOW_SIZE * 2, 0, v9 + 200 + SHADOW_SIZE * 2),
				Position = UDim2.new(-SHADOW_SIZE, 0, 1, -v9 - SHADOW_SIZE),
				ZIndex = 2,
				slice = {
					center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1),
					scale = 2
				},
				imageStyle = v4.Color.Extended.Black.Black_10
			})
		end

		v30.Shadow = shadow
		local backdrop

		if Flags.FoundationBottomSheetInternalBackdrop then
			backdrop = React.createElement(Backdrop, {
				transparency = transparency,
				onActivated = function()
					v19()
				end,
				Size = UDim2.fromScale(1, 2),
				ZIndex = 1,
				testId = `{v2.testId}--backdrop`
			})
		else
			backdrop = React.createElement(View, {
				Size = UDim2.fromScale(1, 2),
				Position = UDim2.fromScale(0, -0.5),
				ZIndex = 1,
				stateLayer = { affordance = StateLayerAffordance.None },
				backgroundStyle = transparency:map(function(p3: number)
					return {
						Color3 = v4.Color.Common.Backdrop.Color3,
						Transparency = math.lerp(v4.Color.Common.Backdrop.Transparency, 1, p3)
					}
				end),
				onActivated = function()
					v19()
				end,
				testId = `{v2.testId}--backdrop`
			})
		end

		v30.Backdrop = backdrop
		return (createPortal(createElement2(View, v27, createElement3("ScrollingFrame", v28, v30)), v3))
	end

	return v3
end

return React.memo(React.forwardRef(BottomSheet))
