local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent
local Dash = require(parent.Dash)
local Otter = require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local ReactRoblox = require(parent.ReactRoblox)
local ReactUtils = require(parent.ReactUtils)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local StateLayerAffordance = require(foundation.Enums.StateLayerAffordance)
local useElevation = require(foundation.Providers.Elevation.useElevation)
local useOverlay = require(foundation.Providers.Overlay.useOverlay)
local useTokens = require(foundation.Providers.Style.useTokens)
local withDefaults = require(foundation.Utility.withDefaults)
local ElevationProvider = require(foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope
local ElevationLayer = require(foundation.Enums.ElevationLayer)

local Constants = require(foundation.Constants)
local useScreen = require(foundation.Providers.Overlay.useScreen)
local SheetContext = require(script.Parent.SheetContext)
local Types = require(script.Parent.Types)

local SheetType = require(script.Parent.SheetType)

local childrenHasFullBleed = require(script.Parent.childrenHasFullBleed)
local getHardwareSafeAreaInsets = require(script.Parent.getHardwareSafeAreaInsets)
local useHardwareInsets = require(script.Parent.useHardwareInsets)
local useScreenHeight = require(script.Parent.useScreenHeight)

local Image = require(foundation.Components.Image)
local View = require(foundation.Components.View)

local usePreferences = require(foundation.Providers.Preferences.usePreferences)

local defineFastInt = game:DefineFastInt("FoundationBottomSheetIOSInsetWorkaroundDelayMs", 100)

local defineFastFlag = game:DefineFastFlag("FoundationBottomSheetIOSInsetWorkaround", false)

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

local function useStableGuiHeight(instance)
	local v2 = not instance and 0 or instance.AbsoluteSize.Y
	local state, setState = React.useState(v2)
	local ref = React.useRef(v2)
	local ref2 = React.useRef(0)

	local v3 = React.useCallback(function(current: number)
		if ref.current == current then
			return
		end

		ref.current = current
		setState(current)
	end, {})

	React.useLayoutEffect(function()
		ref2.current += 1

		if not instance then
			v3(0)
			return function()
				ref2.current += 1
			end
		end

		local function updateHeight()
			local y = instance.AbsoluteSize.Y

			if ref.current <= 0 or y <= ref.current then
				ref2.current += 1
				v3(y)
			else
				ref2.current += 1
				local current = ref2.current

				task.delay(defineFastInt / 1000, function()
					if ref2.current ~= current or instance.AbsoluteSize.Y ~= y then
						return
					end

					v3(y)
				end)
			end
		end

		updateHeight()
		local absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateHeight)

		return function()
			ref2.current += 1
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { instance, v3 })

	return state
end

local function useStableScreenHeight() -- 2 equivalent calls inferred from this helper
	return useStableGuiHeight(useScreen())
end

local function useStableBottomSafeAreaPadding(instance)
	local bottom = getHardwareSafeAreaInsets().bottom
	local state, setState = React.useState(bottom)
	local ref = React.useRef(bottom)
	local ref2 = React.useRef(0)

	local v2 = React.useCallback(function(current: number)
		if ref.current == current then
			return
		end

		ref.current = current
		setState(current)
	end, {})

	React.useEffect(function()
		ref2.current += 1

		if not instance then
			return function()
				ref2.current += 1
			end
		end

		local function updateBottomInset()
			local bottom2 = getHardwareSafeAreaInsets().bottom

			if ref.current <= bottom2 then
				ref2.current += 1
				v2(bottom2)
			else
				ref2.current += 1
				local current = ref2.current

				task.delay(defineFastInt / 1000, function()
					local bottom3 = getHardwareSafeAreaInsets().bottom

					if ref2.current ~= current or bottom3 ~= bottom2 then
						return
					end

					v2(bottom2)
				end)
			end
		end

		updateBottomInset()
		local absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateBottomInset)

		return function()
			ref2.current += 1
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { instance, v2 })

	return state
end

local function getIOSInsetWorkaroundValues(p)
	return useStableScreenHeight(), useStableGuiHeight(p), useStableBottomSafeAreaPadding(p) -- inferred equivalent call
end

local function BottomSheet(p, p2)
	local v2 = withDefaults(p, v)
	local v3 = useOverlay()
	local v4 = useTokens()
	local owner = useElevation(ElevationLayer.Sheet, { stackAboveOwner = false })

	local reducedMotion = usePreferences().reducedMotion

	local setState = nil
	local safeAreaPadding = nil
	local v5, state

	if defineFastFlag then
		v5 = useStableScreenHeight() -- inferred equivalent call

		state = useStableGuiHeight(v3)
		safeAreaPadding = useStableBottomSafeAreaPadding(v3)
	else
		v5 = useScreenHeight()

		state, setState = React.useState(not v3 and 0 or v3.AbsoluteSize.Y)
	end

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

	for _, snapPoint in snapPoints do
		local v9 = v7(snapPoint)

		if v8 < v9 then
			v8 = v9
		end
	end

	local v9 = math.min(v8, v5)

	if state > 0 then
		v9 = math.min(v9, state)
	end

	if not defineFastFlag then
		safeAreaPadding = useHardwareInsets(v3).bottom

		React.useLayoutEffect(function()
			if not v3 then
				setState(0)
				return
			end

			local function updateOverlayAvailableHeight() -- 1 equivalent call inferred from this helper
				setState(v3.AbsoluteSize.Y)
			end

			updateOverlayAvailableHeight() -- inferred equivalent call
			local absoluteSizeChangedConnection = v3:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateOverlayAvailableHeight)

			return function()
				absoluteSizeChangedConnection:Disconnect()
			end
		end, { v3 })
	end

	local ref = React.useRef(0)
	local ref2 = React.useRef(false)

	local v10, v11 = useAnimatedBinding(1, function()
		if ref2.current then
			v2.onClose()
		end
	end)
	local sheetHeightAvailable, setSheetHeightAvailable = React.useBinding(-safeAreaPadding)
	local actionsHeight, setActionsHeight = React.useBinding(0)
	local hasActionsDivider, setHasActionsDivider = React.useBinding(false)
	local hasHeader, setHasHeader = React.useBinding(false)
	local hasFullBleed = childrenHasFullBleed(v2.children)
	local fullBleedHeight, setFullBleedHeight = React.useBinding(0)

	local ref3 = React.useRef(0)
	local ref4 = React.useRef(nil)
	local innerScrollY, v12 = React.useBinding(0)
	local innerScrollingEnabled, v13 = React.useBinding(false)

	local ref5 = React.useRef(false)
	local ref6 = React.useRef(0)
	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(false)
	local ref9 = React.useRef(0)

	local v14 = React.useCallback(function()
		if ref7.current then
			ref7.current:Disconnect()
			ref7.current = nil
		end

		ref6.current = 0
		ref8.current = false
	end, {})

	local v15 = React.useCallback(function(p3: number)
		v14()
		ref8.current = true

		if ref4.current then
			ref4.current:ResetScrollVelocity()
		end

		local RunService = game:GetService("RunService")
		ref7.current = RunService.Heartbeat:Connect(function(dt)
			if not (ref4.current and ref8.current) then
				v14()
				return
			end

			local v15, current = advanceCriticalDampedSpring(ref4.current.CanvasPosition.Y, ref9.current, p3, dt) -- inferred equivalent call

			ref9.current = current
			ref4.current.CanvasPosition = Vector2.new(0, v15)
			local v16

			if math.abs(p3 - ref4.current.CanvasPosition.Y) < 0.5 then
				v16 = math.abs(ref9.current) < 1
			else
				v16 = false
			end

			if v16 then
				ref4.current.CanvasPosition = Vector2.new(0, p3)
				v14()
			end
		end)
	end, { v14 })

	local v16 = React.useCallback(function(p3: number)
		return math.min(v7(p3), v9) + safeAreaPadding
	end, { safeAreaPadding, v7, v9 })

	local v17 = React.useCallback(function(current: number)
		ref.current = current
		v15(v16(snapPoints[current]))
	end, { v16, snapPoints })

	local v18 = React.useCallback(function(current: number)
		v14()
		ref.current = current

		if ref4.current then
			ref4.current.CanvasPosition = Vector2.new(0, v16(snapPoints[current]))
		end
	end, { v14, v16, snapPoints })

	local ref10 = React.useRef(0)
	React.useEffect(function()
		if not v3 then
			return
		end

		local current = ref10.current
		ref10.current = state

		if current <= 0 or current == state then
			return
		end

		local v19 = ref.current

		if v19 <= 0 or #snapPoints < v19 then
			v19 = v2.defaultSnapPointIndex
		end

		if reducedMotion then
			v18(v19)
		else
			v17(v19)
		end
	end, { v3, state, v17, v18, reducedMotion, v2.defaultSnapPointIndex, snapPoints })

	local v19 = React.useCallback(function(flag: boolean?)
		if ref2.current then
			return
		end

		if reducedMotion and not flag then
			ref2.current = true
			v14()

			if ref4.current then
				ref4.current.CanvasPosition = Vector2.new(0, 0)
			end

			v11((Otter.instant(1)))
		else
			ref9.current = -ref6.current
			v15(0)
			v11(Otter.ease(1, { duration = v4.Time.Time_100 }))

			ref2.current = true
		end
	end, { v15, v14, reducedMotion })

	local v20 = React.useCallback(function()
		local v20 = innerScrollY:getValue() <= 0
		local v21 = ref3.current >= math.floor(v9 + safeAreaPadding)

		if ref6.current > 0 and v20 and ref5.current then
			v13(false)
		elseif ref6.current <= 0 and v21 then
			v13(true)
		end
	end, { v9, safeAreaPadding })

	local v21 = React.useCallback(function()
		local current = ref6.current
		local v21 = ref3.current - current / 2.35

		local v22 = {
			{ index = 0, position = 0 }
		}

		for k, snapPoint in snapPoints do
			table.insert(v22, { index = k, position = v16(snapPoint) })
		end

		table.sort(v22, function(a, b): boolean
			return math.abs(a.position - v21) < math.abs(b.position - v21)
		end)

		local v23 = v22[1]

		if not ref5.current then
			ref9.current = -current

			if v23.index == 0 then
				v19(true)
			else
				v17(v23.index)
			end
		end
	end, { snapPoints, v17, v16, v19 })

	React.useEffect(function()
		if v3 then
			if reducedMotion then
				v18(v2.defaultSnapPointIndex)
				v11(Otter.instant(0))
			else
				v17(v2.defaultSnapPointIndex)
				v11(Otter.ease(0, { duration = v4.Time.Time_100 }))
			end

			if math.min(v7(snapPoints[v2.defaultSnapPointIndex]), v9) == v9 then
				v13(true)
			end
		end

		return function()
			v14()
		end
	end, { v3, snapPoints, v2.defaultSnapPointIndex, v17, v7, v18, reducedMotion })

	React.useEffect(function()
		local UserInputService = game:GetService("UserInputService")
		local touchPanConnection = UserInputService.TouchPan:Connect(function(_, _, p3, _)
			ref6.current = p3.Y
			v20()
		end)
		local UserInputService2 = game:GetService("UserInputService")
		local inputBeganConnection = UserInputService2.InputBegan:Connect(function()
			ref5.current = true
			ref6.current = 0
			v14()
		end)
		local UserInputService3 = game:GetService("UserInputService")
		local inputEndedConnection = UserInputService3.InputEnded:Connect(function()
			if ref5.current == false then
				return
			end

			ref5.current = false

			ref6.current = not ref4.current and 0 or ref4.current:GetScrollVelocity().Y

			if ref3.current >= math.floor(v9 + safeAreaPadding) or ref2.current then
				v13(true)
			else
				v21()
			end
		end)

		return function()
			touchPanConnection:Disconnect()
			inputBeganConnection:Disconnect()
			inputEndedConnection:Disconnect()
		end
	end, { v3, v21, v20, v14 })

	local ref11 = React.useRef(nil)
	local state3, setState3 = React.useState(nil)

	local state4, setState4 = React.useState(nil)
	local ref12 = ReactUtils.useComposedRef(p2, setState4)

	React.useImperativeHandle(v2.sheetRef, function()
		return { close = v19 }
	end, {})

	local v22 = React.useMemo(function()
		return {
			actionsHeight = actionsHeight,
			setActionsHeight = setActionsHeight,
			hasActionsDivider = hasActionsDivider,
			setHasActionsDivider = setHasActionsDivider,
			sheetHeightAvailable = sheetHeightAvailable,
			setSheetHeightAvailable = setSheetHeightAvailable,
			safeAreaPadding = safeAreaPadding,
			bottomPadding = 200,
			innerScrollingEnabled = innerScrollingEnabled,
			innerScrollY = innerScrollY,
			setInnerScrollY = function(p3: number)
				v12(p3)
				v20()
			end,
			hasHeader = hasHeader,
			setHasHeader = setHasHeader,
			hasFullBleed = hasFullBleed,
			fullBleedHeight = fullBleedHeight,
			setFullBleedHeight = setFullBleedHeight,
			closeSheet = v19,
			hasRadius = true,
			sheetType = SheetType.Bottom,
			innerSurface = state4,
			testId = v2.testId,
			closeAffordanceRef = ref11,
			contentStartRef = state3,
			setContentStartRef = setState3
		}
	end, { v2.testId, v19, safeAreaPadding, v20, state4, ref11, state3, hasFullBleed })

	local createElement = React.createElement
	local v23 = {
		ZIndex = 3,
		backgroundStyle = v4.Color.Content.Muted,
		Position = 0,
		AnchorPoint = 0,
		tag = "align-y-center size-1000-100 padding-y-small radius-small",
		testId = 0
	}
	local v24

	if hasFullBleed then
		v24 = v4.Padding.Small
	else
		v24 = -v4.Padding.XSmall
	end

	v23.Position = UDim2.new(0.5, 0, 0, v24)
	v23.AnchorPoint = Vector2.new(0.5, 0)

	v23.testId = `{v2.testId}--gripper`
	local element = createElement(View, v23, {
		TouchTarget = React.createElement(View, {
			tag = "size-1000-600",
			stateLayer = { affordance = StateLayerAffordance.None },
			onActivated = function()
				ref5.current = false

				if #snapPoints > 1 then
					local v25 = ref.current % #snapPoints + 1

					if reducedMotion then
						v18(v25)
					else
						v17(v25)
					end

					if math.min(v7(snapPoints[v25]), v9) == v9 then
						v13(true)
					end
				else
					v19()
				end
			end
		})
	})

	if v3 then
		local createPortal = ReactRoblox.createPortal
		local createElement2 = React.createElement

		local v25 = {
			ZIndex = owner.zIndex,
			ref = ref12,
			selection = Types.nonSelectable,
			selectionGroup = Types.isolatedSelectionGroup,
			Size = 0,
			tag = 0,
			testId = 0
		}
		local size

		if defineFastFlag then
			size = UDim2.new(1, 0, 0, state)
		end

		v25.Size = size

		v25.tag = not defineFastFlag and "size-full" or nil
		v25.testId = `{v2.testId}--surface`

		local createElement3 = React.createElement
		local size2

		if defineFastFlag then
			size2 = UDim2.new(1, 0, 0, state)
		else
			size2 = UDim2.fromScale(1, 1)
		end

		local v26 = {
			Size = size2,
			CanvasSize = UDim2.new(1, 0, 1, v9 + safeAreaPadding),
			ClipsDescendants = false,
			BackgroundTransparency = 1,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarThickness = 0,
			ref = ref4,
			[React.Change.CanvasPosition] = function(p3)
				ref3.current = p3.CanvasPosition.Y
				setSheetHeightAvailable(ref3.current - safeAreaPadding - v4.Margin.Small)
				v20()

				if ref3.current <= 0 then
					v19()
				end
			end
		}

		local createElement4 = React.createElement
		local v27 = {
			Size = UDim2.new(1, 0, 1, 200 - v9 - safeAreaPadding),
			Position = UDim2.new(0, 0, 1, -v9),
			ZIndex = 3
		}

		local createElement5 = React.createElement
		local size3

		if v2.snapPoints == nil then
			size3 = UDim2.fromScale(1, 0)
		else
			size3 = UDim2.new(1, 0, 0, v9 + 200)
		end

		local automaticSize

		if v2.snapPoints == nil then
			automaticSize = Enum.AutomaticSize.Y
		end

		return (createPortal(createElement2(View, v25, createElement3("ScrollingFrame", v26, {
			SheetContainer = createElement4(View, v27, {
				Sheet = createElement5(View, {
					Size = size3,
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
						{ value = v22 },
						React.createElement(ElevationOwnerScope, { owner = owner }, v2.children)
					)
				})
			}),
			Shadow = React.createElement(Image, {
				Image = SHADOW_IMAGE,
				Size = UDim2.new(1, SHADOW_SIZE * 2, 0, v9 + 200 + SHADOW_SIZE * 2),
				Position = UDim2.new(-SHADOW_SIZE, 0, 1, -v9 - SHADOW_SIZE),
				ZIndex = 2,
				slice = {
					center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1),
					scale = 2
				},
				imageStyle = v4.Color.Extended.Black.Black_10
			}),
			Backdrop = React.createElement(View, {
				Size = UDim2.fromScale(1, 2),
				Position = UDim2.fromScale(0, -0.5),
				ZIndex = 1,
				stateLayer = { affordance = StateLayerAffordance.None },
				backgroundStyle = v10:map(function(p3: number)
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
		})), v3))
	end

	return v3
end

return React.memo(React.forwardRef(BottomSheet))
