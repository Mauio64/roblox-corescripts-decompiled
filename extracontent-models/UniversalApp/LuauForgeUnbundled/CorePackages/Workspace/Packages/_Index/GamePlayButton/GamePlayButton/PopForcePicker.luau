local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SignalsReact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/InputHandlers")
local PopForcePickerModel = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PopForcePickerModel")
local PopForcePickerStore = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PopForcePickerStore")
local PopForcePickerView = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PopForcePickerView")

local navigateBack = FocusNavigationUtils.FocusNavigationEventNameEnum.NavigateBack
local navigateBacks = {
	[Enum.KeyCode.ButtonB] = navigateBack,
	[Enum.KeyCode.Escape] = navigateBack
}

local function PopForcePicker(props)
	local v5 = React.useMemo(function()
		local v6 = props.store

		if v6 then
			return v6
		end

		if props.getService then
			return (PopForcePickerStore.createStore(props.getService))
		end

		v6 = PopForcePickerStore.getStore(false)
		return v6
	end, { props.store, props.getService })
	local v6 = SignalsReact.useSignalState(v5.getSelection)
	local v7 = SignalsReact.useSignalState(v5.getSupported)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState(nil)
	local v8 = Foundation.Hooks.useTokens()
	local v9 = Foundation.Hooks.useOverlay()
	local state5, setState5 = React.useState(Vector2.new(1024, 768))
	local state6, setState6 = React.useState(0)
	local v10 = React.useCallback(function(p2)
		setState6(p2.AbsoluteCanvasSize.Y)
	end, {})
	React.useLayoutEffect(function()
		if not (v9 and state) then
			return nil
		end

		local function updateSize()
			setState5(v9.AbsoluteSize)
		end

		setState5(v9.AbsoluteSize)

		local absoluteSizeChangedConnection = v9:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { v9, state })

	React.useEffect(function()
		v5.refresh()
	end, { v5 })

	local v11 = React.useCallback(function()
		setState(false)
	end, {})
	local v12 = React.useMemo(function()
		return {
			[navigateBack] = {
				phase = "Bubble",
				handler = InputHandlers.onRelease(function(object)
					v11()
					object:cancel()
				end)
			}
		}
	end, { v11 })
	local v13 = FocusNavigationUtils.useFocusRoot({
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = state and v7,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v12
	})

	local v14 = React.useCallback(function()
		if state then
			v11()
			return
		end

		v5.refresh()

		setState3(v5.getSnapshot() or {})
		setState2(false)
		setState4(nil)
		setState(true)
	end, { state, v11, v5 })

	local v15 = React.useCallback(function(p2)
		if v5.select(p2) then
			v11()
		else
			setState4("Could not save this location. Try again.")
		end
	end, { v5, v11 })
	local v16 = React.useCallback(function()
		setState2(function(p2): boolean
			return not p2
		end)
	end, {})

	local v17 = React.useMemo(function()
		return PopForcePickerModel.buildRoster(state3, v6)
	end, { state3, v6 })
	local visibleRoster = PopForcePickerModel.getVisibleRoster(v17, v6, state2)

	if v7 then
		return React.createElement(PopForcePickerView, {
			LayoutOrder = props.LayoutOrder,
			compact = props.compact,
			forcedPop = v6,
			rows = visibleRoster,
			hasMore = #v17 > 5,
			showAll = state2,
			isOpen = state,
			errorText = state4,
			tokens = v8,
			anchorRef = ref,
			menuSize = Vector2.new(
				math.min(v8.Size.Size_1200 * 7, (math.max(1, state5.X - v8.Margin.Medium * 2))),
				(math.min(state6, (math.max(1, state5.Y - v8.Margin.Medium * 2))))
			),
			onCanvasSizeChanged = v10,
			focusRef = v13,
			onToggleMenu = v14,
			onClose = v11,
			onSelect = v15,
			onToggleShowAll = v16
		})
	end

	return nil
end

return React.memo(PopForcePicker)
