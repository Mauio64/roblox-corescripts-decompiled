local parent = script:FindFirstAncestor("GamePlayButton").Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local PopForcePickerModel = require(script.Parent.PopForcePickerModel)
local PopForcePickerStore = require(script.Parent.PopForcePickerStore)
local PopForcePickerView = require(script.Parent.PopForcePickerView)

local NavigateBack = FocusNavigationUtils.FocusNavigationEventNameEnum.NavigateBack
local navigateBacks = {
	[Enum.KeyCode.ButtonB] = NavigateBack,
	[Enum.KeyCode.Escape] = NavigateBack
}

local function PopForcePicker(props)
	local v = React.useMemo(function()
		local store = props.store

		if store then
			return store
		end

		if props.getService then
			return (PopForcePickerStore.createStore(props.getService))
		end

		return (PopForcePickerStore.getStore(false))
	end, { props.store, props.getService })
	local forcedPop = SignalsReact.useSignalState(v.getSelection)
	local v2 = SignalsReact.useSignalState(v.getSupported)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState(nil)
	local tokens = Foundation.Hooks.useTokens()
	local v3 = Foundation.Hooks.useOverlay()
	local state5, setState5 = React.useState(Vector2.new(1024, 768))
	local state6, setState6 = React.useState(0)
	local onCanvasSizeChanged = React.useCallback(function(p)
		setState6(p.AbsoluteCanvasSize.Y)
	end, {})
	React.useLayoutEffect(function()
		if not (v3 and state) then
			return nil
		end

		local function updateSize() -- 1 equivalent call inferred from this helper
			setState5(v3.AbsoluteSize)
		end

		updateSize() -- inferred equivalent call
		local absoluteSizeChangedConnection = v3:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { v3, state })

	React.useEffect(function()
		v.refresh()
	end, { v })

	local onClose = React.useCallback(function()
		setState(false)
	end, {})
	local eventHandlers = React.useMemo(function()
		return {
			[NavigateBack] = {
				phase = "Bubble",
				handler = InputHandlers.onRelease(function(object)
					onClose()
					object:cancel()
				end)
			}
		}
	end, { onClose })
	local focusRef = FocusNavigationUtils.useFocusRoot({
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = state and v2,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	local onToggleMenu = React.useCallback(function()
		if state then
			onClose()
			return
		end

		v.refresh()

		setState3(v.getSnapshot() or {})
		setState2(false)
		setState4(nil)
		setState(true)
	end, { state, onClose, v })

	local onSelect = React.useCallback(function(p: string)
		if v.select(p) then
			onClose()
		else
			setState4("Could not save this location. Try again.")
		end
	end, { v, onClose })
	local onToggleShowAll = React.useCallback(function()
		setState2(function(p): boolean
			return not p
		end)
	end, {})

	local v4 = React.useMemo(function()
		return PopForcePickerModel.buildRoster(state3, forcedPop)
	end, { state3, forcedPop })
	local visibleRoster = PopForcePickerModel.getVisibleRoster(v4, forcedPop, state2)

	if v2 then
		return React.createElement(PopForcePickerView, {
			LayoutOrder = props.LayoutOrder,
			compact = props.compact,
			forcedPop = forcedPop,
			rows = visibleRoster,
			hasMore = #v4 > 5,
			showAll = state2,
			isOpen = state,
			errorText = state4,
			tokens = tokens,
			anchorRef = ref,
			menuSize = Vector2.new(
				math.min(tokens.Size.Size_1200 * 7, (math.max(1, state5.X - tokens.Margin.Medium * 2))),
				(math.min(state6, (math.max(1, state5.Y - tokens.Margin.Medium * 2))))
			),
			onCanvasSizeChanged = onCanvasSizeChanged,
			focusRef = focusRef,
			onToggleMenu = onToggleMenu,
			onClose = onClose,
			onSelect = onSelect,
			onToggleShowAll = onToggleShowAll
		})
	end

	return nil
end

return React.memo(PopForcePicker)
