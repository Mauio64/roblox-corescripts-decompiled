local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local Modules = CoreGui.RobloxGui.Modules
local VerticalClothingListTile = require(Modules.AvatarExperience.LayeredClothingSort.Components.VerticalClothingListTile)

local function useFocusNavigationBindings(p1, p2, t1: {[any]: any}) -- line: 34
	-- upvalues: ReactFocusNavigation (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v20 = ReactFocusNavigation.useEventMap(p2, p1)
	local v21 = React.useMemo(function() -- line: 37
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), t1 (copy)
		return {
			[FocusNavigationEventNameEnum.SelectClothingTile] = {
				handler = InputHandlers.onRelease(t1.onSelect)
			},
			[FocusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(t1.onConfirm)
			},
			[FocusNavigationEventNameEnum.MoveClothingTileUpOne] = if not t1.onMoveTileUpOne then nil else {
				handler = InputHandlers.onRelease(t1.onMoveTileUpOne)
			},
			[FocusNavigationEventNameEnum.MoveClothingTileDownOne] = if not t1.onMoveTileDownOne then nil else {
				handler = InputHandlers.onRelease(t1.onMoveTileDownOne)
			},
			[FocusNavigationEventNameEnum.CancelAndReset] = if not t1.onCancelAndReset then nil else {
				handler = InputHandlers.onRelease(function(p3) -- line: 57
					-- upvalues: t1 (copy)
					p3.cancelled = true
					t1.onCancelAndReset()
				end)
			},
			[FocusNavigationEventNameEnum.RemoveClothingTile] = if not t1.onRemoveClothingTile then nil else {
				handler = InputHandlers.onRelease(t1.onRemoveClothingTile)
			},
			[FocusNavigationEventNameEnum.MoveClothingTile] = if not t1.displayMoveIcon then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 70
				end)
			}
		}
	end, {
		t1.onSelect,
		t1.onConfirm,
		t1.onMoveTileUpOne,
		t1.onMoveTileDownOne,
		t1.onCancelAndReset,
		t1.onRemoveClothingTile,
		t1.displayMoveIcon
	})

	return ReactFocusNavigation.useEventHandlerMap(v21, v20)
end

return (Roact.forwardRef(function(p5, p6) -- line: 90
	-- upvalues: React (copy), useFocusGuiObject (copy), FocusNavigationEventNameEnum (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), useDescendantHasFocus (copy), RunService (copy), UserInputService (copy), Roact (copy), VerticalClothingListTile (copy)
	local v24 = React.useRef(false)
	local v25 = useFocusGuiObject()
	local v26 = React.useMemo(function() -- line: 95
		-- upvalues: p5 (copy), FocusNavigationEventNameEnum (copy)
		return {
			[Enum.KeyCode.ButtonA] = if p5.selectedAssetId ~= nil then FocusNavigationEventNameEnum.Confirm else FocusNavigationEventNameEnum.SelectClothingTile,
			[Enum.KeyCode.DPadUp] = FocusNavigationEventNameEnum.MoveClothingTileUpOne,
			[Enum.KeyCode.DPadDown] = FocusNavigationEventNameEnum.MoveClothingTileDownOne,
			[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.CancelAndReset,
			[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.RemoveClothingTile,
			[Enum.KeyCode.Thumbstick1] = FocusNavigationEventNameEnum.MoveClothingTile
		}
	end, { p5.selectedAssetId })
	local v27 = React.useCallback(function() -- line: 108
		-- upvalues: p5 (copy)
		p5.onSelectTile(p5.asset)
	end, {
		p5.onSelectTile,
		p5.asset
	})
	local v28 = React.useCallback(function() -- line: 112
		-- upvalues: p5 (copy)
		p5.onConfirmTile()
	end, { p5.onConfirmTile })
	local v29 = React.useCallback(function() -- line: 116
		-- upvalues: p5 (copy)
		p5.onMoveTileUpOne(p5.tileIndex, p5.asset)
	end, {
		p5.onMoveTileUpOne,
		p5.tileIndex,
		p5.asset
	})
	local v30 = React.useCallback(function() -- line: 120
		-- upvalues: p5 (copy)
		p5.onMoveTileDownOne(p5.tileIndex, p5.asset)
	end, {
		p5.onMoveTileDownOne,
		p5.tileIndex,
		p5.asset
	})
	local v31 = React.useCallback(function() -- line: 124
		-- upvalues: p5 (copy)
		p5.onCancelAndReset()
	end, { p5.onCancelAndReset })
	local v32 = React.useCallback(function() -- line: 128
		-- upvalues: p5 (copy)
		p5.onRemoveClothingTile(p5.asset)
	end, {
		p5.onRemoveClothingTile,
		p5.asset
	})
	local v33 = p5.selectedAssetId == p5.asset.id
	local v34 = useFocusNavigationBindings(p6, v26, {
		onSelect = v27,
		onConfirm = v28,
		onMoveTileUpOne = if not v33 then nil else v29,
		onMoveTileDownOne = if not v33 then nil else v30,
		onCancelAndReset = if not v33 then nil else v31,
		onRemoveClothingTile = if not v33 then nil else v32,
		displayMoveIcon = v33
	})
	local v35 = useTableWrappedCallbackRef(v34)

	React.useEffect(function() -- line: 144
		-- upvalues: p5 (copy), v24 (copy), v25 (copy), v35 (copy)
		if p5.lastInputIsGamepad and (p5.tileIndex == 1 and not v24.current) then
			v25(v35.current)
		end

		v24.current = true
	end, {
		p5.lastInputIsGamepad,
		p5.tileIndex,
		v25
	})

	local v36 = useDescendantHasFocus(v35.current)

	React.useEffect(function() -- line: 155
		-- upvalues: v36 (copy), RunService (copy), p5 (copy), UserInputService (copy)
		if not v36 then
			return
		end

		local u37 = nil
		local connection = RunService.Heartbeat:Connect(function(_) -- line: 161
			-- upvalues: u37 (ref), p5 (copy)
			if u37 and (u37.KeyCode == Enum.KeyCode.Thumbstick1 and p5.selectedAssetId == p5.asset.id) then
				p5.onMoveThumbstickInput(u37, p5.tileIndex, p5.asset)
			end
		end)
		local connection2 = UserInputService.InputChanged:Connect(function(input, _) -- line: 170
			-- upvalues: u37 (ref)
			if input.KeyCode == Enum.KeyCode.Thumbstick1 then
				if input.UserInputState == Enum.UserInputState.Change then
					u37 = input

					return
				end

				if input.UserInputState == Enum.UserInputState.End then
					u37 = nil
				end
			end
		end)

		return function() -- line: 180
			-- upvalues: connection (copy), connection2 (copy)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end
	end, {
		p5.onMoveThumbstickInput,
		p5.tileIndex,
		p5.asset,
		p5.selectedAssetId,
		v36
	})

	return Roact.createElement(VerticalClothingListTile, {
		asset = p5.asset,
		selectedAssetId = p5.selectedAssetId,
		positionYOffset = p5.positionYOffset,
		dragging = p5.dragging,
		positionBinding = p5.positionBinding,
		isTileSelected = p5.isTileSelected,
		tileIndex = p5.tileIndex,
		contextualOptionsVisible = p5.contextualOptionsVisible,
		updateContextualOptionsVisible = p5.updateContextualOptionsVisible,
		resetSelectedTile = p5.resetSelectedTile,
		initializeDrag = p5.initializeDrag,
		onEndClick = p5.onEndClick,
		tileRef = p5.tileRef,
		lastInputIsGamepad = p5.lastInputIsGamepad,
		[Roact.Ref] = v35
	})
end))
