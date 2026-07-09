local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useFocusController = RoactGamepad.useFocusController
local SlotTray = require(CorePackages.Packages.UIBlox).App.Control.Slot.SlotTray
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local React = require(CorePackages.Packages.React)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local t = require(CorePackages.Packages.t)
local FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

local function selectSlotInfo(p1) -- line: 36
	return p1.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo
end
local function selectSelectedSlot(p2) -- line: 40
	return p2.AvatarExperience.AvatarEditor.EquippedEmotes.selectedSlot
end

local t1 = {
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.EquipSlotsSelectSlot,
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p3, p4: ((...any) -> ...any), p5: ((...any) -> ...any)) -- line: 49
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v33 = ReactFocusNavigation.useEventMap(t1, p3)
	local v34 = React.useMemo(function() -- line: 51
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p4 (copy), p5 (copy)
		return {
			[FocusNavigationEventNameEnum.EquipSlotsSelectSlot] = {
				handler = InputHandlers.onRelease(function(_) -- line: 54
					-- upvalues: p4 (copy)
					p4()
				end)
			},
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(_) -- line: 59
					-- upvalues: p5 (copy)
					p5()
				end)
			}
		}
	end, {
		p4,
		p5
	})

	return ReactFocusNavigation.useEventHandlerMap(v34, v33)
end

local v25 = ArgCheck.wrap(t.strictInterface({
	slotsCount = t.integer,
	lockNavigationCallback = t.optional(t.callback),
	unlockNavigationCallback = t.optional(t.callback),
	onActivated = t.optional(t.callback),
	LayoutOrder = t.optional(t.integer),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	itemsListRef = t.table,
	forwardRef = t.optional(t.table),
	onFocusChanged = t.optional(t.callback),
	itemsListFocused = t.optional(t.boolean),
	darkenItemsGrid = t.optional(t.boolean)
}))

local function noOp() -- line: 98
end
local function EquipSlots(t2: {[any]: any}) -- line: 100
	-- upvalues: v25 (copy), useSelector (copy), selectSlotInfo (copy), selectSelectedSlot (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), useFocusController (copy), React (copy), noOp (copy), useFocusGuiObject (copy), FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad (copy), useFocusNavigationBindings (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Roact (copy), SlotTray (copy), RoactGamepad (copy)
	assert(v25(t2))

	local v36 = useSelector(selectSlotInfo)
	local v37 = useSelector(selectSelectedSlot)
	local v38 = if not FFlagAXMigrateAXToGlobalAutofocus then useFocusController() else nil
	local v39 = React.useRef(nil)
	local v40, v41 = React.useState(nil)
	local v42 = React.useCallback(function(p8) -- line: 112
		-- upvalues: v41 (copy)
		local v62 = math.round(p8.AbsoluteSize.X)

		v41(v62)
	end)
	local v43 = t2.lockNavigationCallback or noOp
	local v44 = t2.unlockNavigationCallback or noOp
	local v45 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useFocusGuiObject()
	local v46 = React.useCallback(function() -- line: 121
		-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), v45 (copy), t2 (copy), v38 (copy)
		if FFlagAXMigrateAXToGlobalAutofocus then
			if v45 and t2.itemsListRef and t2.itemsListRef.current then
				v45(t2.itemsListRef.current)

				return
			end
		else
			v38.moveFocusTo(t2.itemsListRef)
		end
	end, {
		if not FFlagAXMigrateAXToGlobalAutofocus then v38 else v45,
		t2.itemsListRef
	})
	local v47 = React.useCallback(function() -- line: 133
		-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), v45 (copy), t2 (copy), v38 (copy)
		if FFlagAXMigrateAXToGlobalAutofocus then
			if v45 and t2.NextSelectionUp and t2.NextSelectionUp.current then
				v45(t2.NextSelectionUp.current)

				return
			end
		else
			v38.moveFocusUp()
		end
	end, { if not FFlagAXMigrateAXToGlobalAutofocus then v38 else v45 })
	local v48 = if not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then nil else useFocusNavigationBindings(nil, v46, v47)

	React.useEffect(function() -- line: 147
		-- upvalues: v39 (copy), v43 (copy)
		return function() -- line: 148
			-- upvalues: v39 (copy), v43 (copy)
			if v39.current then
				v39.current = nil
				v43()
			end
		end
	end, { v43 })

	local v49 = React.useCallback(function(_, p10) -- line: 156
		-- upvalues: v39 (copy), v43 (copy)
		if p10.UserInputState == Enum.UserInputState.Begin then
			v39.current = p10
			v43()
		end
	end, { v43 })
	local v50 = React.useCallback(function(_, p12) -- line: 163
		-- upvalues: v39 (copy), v44 (copy)
		if p12 == v39.current and p12.UserInputState == Enum.UserInputState.End then
			v39.current = nil
			v44()
		end
	end, { v44 })
	local slotsCount = t2.slotsCount
	local t3 = {}
	local v53 = t2.itemsListFocused or t2.darkenItemsGrid

	for i = 1, slotsCount do
		local v55 = v36[i] and v36[i].assetId or nil
		local v56 = v37 == i
		local v57 = nil

		if v55 then
			v57 = getRbxthumbWithTypeSizeAndOptions(v55, Constants.RbxthumbTypes.Asset, 150)
		end

		t3[i] = {
			thumbnail = v57,
			displayText = if not v57 then tostring(i) else nil,
			isDisabled = v53 and not v56
		}
	end

	local forwardRef = t2.forwardRef

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 72),
		[Roact.Change.AbsoluteSize] = v42,
		ref = if not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then nil else v48
	}, {
		SlotTray = Roact.createElement(SlotTray, {
			defaultSelectedSlotIndex = v37,
			width = v40,
			inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus and not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then {
				SelectSlot = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 207
					-- upvalues: v38 (copy), t2 (copy)
					v38.moveFocusTo(t2.itemsListRef)
				end, {
					key = "Feature.Avatar.Action.SelectSlot"
				}),
				MoveToNav = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 212
					-- upvalues: v38 (copy)
					v38.moveFocusUp()
				end)
			} else nil,
			slots = t3,
			onChange = t2.onActivated,
			onInputBegan = v49,
			onInputEnded = v50,
			darken = v53,
			onFocusChanged = t2.onFocusChanged,
			NextSelectionUp = t2.NextSelectionUp,
			NextSelectionDown = t2.NextSelectionDown,
			scrollingFrameRef = forwardRef
		})
	})
end

return Roact.forwardRef(function(p13, p14) -- line: 231
	-- upvalues: Roact (copy), EquipSlots (copy), Cryo (copy)
	return Roact.createElement(EquipSlots, Cryo.Dictionary.join(p13, {
		forwardRef = p14
	}))
end)
