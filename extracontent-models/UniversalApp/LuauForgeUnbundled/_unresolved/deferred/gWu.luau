local CorePackages = game:GetService("CorePackages")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local useDescendantHasFocus = module.useDescendantHasFocus
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module2 = require("@luauforge/deferred/gWv")

local function useFocusNavigationBindings(p2, p3, data)
	local v5 = ReactFocusNavigation.useEventMap(p3, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.SelectClothingTile] = {
				handler = InputHandlers.onRelease(data.onSelect)
			},
			[focusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(data.onConfirm)
			},
			[focusNavigationEventNameEnum.MoveClothingTileUpOne] = data.onMoveTileUpOne and {
				handler = InputHandlers.onRelease(data.onMoveTileUpOne)
			} or nil,
			[focusNavigationEventNameEnum.MoveClothingTileDownOne] = data.onMoveTileDownOne and {
				handler = InputHandlers.onRelease(data.onMoveTileDownOne)
			} or nil,
			[focusNavigationEventNameEnum.CancelAndReset] = data.onCancelAndReset and {
				handler = InputHandlers.onRelease(function(p4)
					p4.cancelled = true
					data.onCancelAndReset()
				end)
			} or nil,
			[focusNavigationEventNameEnum.RemoveClothingTile] = data.onRemoveClothingTile and {
				handler = InputHandlers.onRelease(data.onRemoveClothingTile)
			} or nil,
			[focusNavigationEventNameEnum.MoveClothingTile] = data.displayMoveIcon and {
				handler = InputHandlers.onRelease(function(p4) end)
			} or nil
		}
	end, {
		data.onSelect,
		data.onConfirm,
		data.onMoveTileUpOne,
		data.onMoveTileDownOne,
		data.onCancelAndReset,
		data.onRemoveClothingTile,
		data.displayMoveIcon
	})

	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

return (Roact.forwardRef(function(props, p2)
	local ref = React.useRef(false)

	local v5 = useFocusGuiObject()

	local v6 = React.useMemo(function()
		local buttonA = Enum.KeyCode.ButtonA
		local v8 = if props.selectedAssetId == nil then focusNavigationEventNameEnum.SelectClothingTile else focusNavigationEventNameEnum.Confirm
		return {
			[buttonA] = v8,
			[Enum.KeyCode.DPadUp] = focusNavigationEventNameEnum.MoveClothingTileUpOne,
			[Enum.KeyCode.DPadDown] = focusNavigationEventNameEnum.MoveClothingTileDownOne,
			[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.CancelAndReset,
			[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.RemoveClothingTile,
			[Enum.KeyCode.Thumbstick1] = focusNavigationEventNameEnum.MoveClothingTile
		}
	end, { props.selectedAssetId })

	local v7 = React.useCallback(function()
		props.onSelectTile(props.asset)
	end, { props.onSelectTile, props.asset })

	local v8 = React.useCallback(function()
		props.onConfirmTile()
	end, { props.onConfirmTile })

	local v9 = React.useCallback(function()
		props.onMoveTileUpOne(props.tileIndex, props.asset)
	end, { props.onMoveTileUpOne, props.tileIndex, props.asset })

	local v10 = React.useCallback(function()
		props.onMoveTileDownOne(props.tileIndex, props.asset)
	end, { props.onMoveTileDownOne, props.tileIndex, props.asset })

	local v11 = React.useCallback(function()
		props.onCancelAndReset()
	end, { props.onCancelAndReset })

	local v12 = React.useCallback(function()
		props.onRemoveClothingTile(props.asset)
	end, { props.onRemoveClothingTile, props.asset })

	local v13 = props.selectedAssetId == props.asset.id

	if not v13 then
		v9 = nil
	end

	if not v13 then
		v10 = nil
	end

	if not v13 then
		v11 = nil
	end

	if not v13 then
		v12 = nil
	end

	local v16 = useTableWrappedCallbackRef((useFocusNavigationBindings(p2, v6, {
		onSelect = v7,
		onConfirm = v8,
		onMoveTileUpOne = v9,
		onMoveTileDownOne = v10,
		onCancelAndReset = v11,
		onRemoveClothingTile = v12,
		displayMoveIcon = v13
	})))

	React.useEffect(function()
		if props.lastInputIsGamepad and props.tileIndex == 1 and not ref.current then
			v5(v16.current)
		end

		ref.current = true
	end, { props.lastInputIsGamepad, props.tileIndex, v5 })

	local v17 = useDescendantHasFocus(v16.current)

	React.useEffect(function()
		if not v17 then
			return
		end

		local v18 = nil
		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if
				v18
				and v18.KeyCode == Enum.KeyCode.Thumbstick1
				and props.selectedAssetId == props.asset.id
			then
				props.onMoveThumbstickInput(v18, props.tileIndex, props.asset)
			end
		end)
		local inputChangedConnection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.Thumbstick1 then
				if input.UserInputState == Enum.UserInputState.Change then
					v18 = input
				elseif input.UserInputState == Enum.UserInputState.End then
					v18 = nil
				end
			end
		end)

		return function()
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
			end

			if inputChangedConnection then
				inputChangedConnection:Disconnect()
			end
		end
	end, {
		props.onMoveThumbstickInput,
		props.tileIndex,
		props.asset,
		props.selectedAssetId,
		v17
	})

	return Roact.createElement(module2, {
		asset = props.asset,
		selectedAssetId = props.selectedAssetId,
		positionYOffset = props.positionYOffset,
		dragging = props.dragging,
		positionBinding = props.positionBinding,
		isTileSelected = props.isTileSelected,
		tileIndex = props.tileIndex,
		contextualOptionsVisible = props.contextualOptionsVisible,
		updateContextualOptionsVisible = props.updateContextualOptionsVisible,
		resetSelectedTile = props.resetSelectedTile,
		initializeDrag = props.initializeDrag,
		onEndClick = props.onEndClick,
		tileRef = props.tileRef,
		lastInputIsGamepad = props.lastInputIsGamepad,
		[Roact.Ref] = v16
	})
end))
