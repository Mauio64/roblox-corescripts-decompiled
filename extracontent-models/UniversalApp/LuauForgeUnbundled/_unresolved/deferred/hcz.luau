local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local slotTray = UIBlox.App.Control.Slot.SlotTray
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dzP")
local t = require(CorePackages.Packages.t)

local fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad

local module2 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module2.FocusNavigationEventNameEnum

local module3 = require("@luauforge/bundled/ciE")
local constants = module3.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module3.Utils.getRbxthumbWithTypeSizeAndOptions

local function selectSlotInfo(p2)
	return p2.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo
end

local function selectSelectedSlot(p2)
	return p2.AvatarExperience.AvatarEditor.EquippedEmotes.selectedSlot
end

local v5 = {
	[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.EquipSlotsSelectSlot,
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p2, callback, callback2)
	local v6 = ReactFocusNavigation.useEventMap(v5, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.EquipSlotsSelectSlot] = {
				handler = InputHandlers.onRelease(function(p3)
					callback()
				end)
			},
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					callback2()
				end)
			}
		}
	end, { callback, callback2 })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

local wrapped = module.wrap(t.strictInterface({
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

local function noOp() end

local function EquipSlots(props)
	assert(wrapped(props))

	local v6 = useSelector(selectSlotInfo)
	local v7 = useSelector(selectSelectedSlot)

	local ref = React.useRef(nil)

	local state, setState = React.useState(nil)

	local v8 = React.useCallback(function(p2)
		setState((math.round(p2.AbsoluteSize.X)))
	end)

	local lockNavigationCallback = props.lockNavigationCallback or noOp
	local unlockNavigationCallback = props.unlockNavigationCallback or noOp
	local v9 = useFocusGuiObject()
	local v10 = React.useCallback(function()
		if v9 and props.itemsListRef and props.itemsListRef.current then
			v9(props.itemsListRef.current)
		end
	end, { v9, props.itemsListRef })

	local v11 = React.useCallback(function()
		if v9 and props.NextSelectionUp and props.NextSelectionUp.current then
			v9(props.NextSelectionUp.current)
		end
	end, { v9 })
	local v12

	if fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
		v12 = useFocusNavigationBindings(nil, v10, v11)
	end

	React.useEffect(function()
		return function()
			if ref.current then
				ref.current = nil
				lockNavigationCallback()
			end
		end
	end, { lockNavigationCallback })

	local v13 = React.useCallback(function(p2, current)
		if current.UserInputState == Enum.UserInputState.Begin then
			ref.current = current
			lockNavigationCallback()
		end
	end, { lockNavigationCallback })

	local v14 = React.useCallback(function(p2, p3)
		if p3 == ref.current and p3.UserInputState == Enum.UserInputState.End then
			ref.current = nil
			unlockNavigationCallback()
		end
	end, { unlockNavigationCallback })

	local slotsCount = props.slotsCount

	local itemsListFocused = props.itemsListFocused or props.darkenItemsGrid
	local v15 = {}

	for i = 1, slotsCount do
		local assetId = if v6[i] then v6[i].assetId or nil else nil
		local v16 = v7 == i
		local v17

		if assetId then
			v17 = getRbxthumbWithTypeSizeAndOptions(assetId, constants.RbxthumbTypes.Asset, 150)
		end

		local v19 = if not v17 then tostring(i) else nil
		v15[i] = {
			thumbnail = v17,
			displayText = v19,
			isDisabled = itemsListFocused and not v16
		}
	end

	local forwardRef = props.forwardRef

	local createElement = Roact.createElement
	local v17 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 72),
		[Roact.Change.AbsoluteSize] = v8
	}

	if not fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
		v12 = nil
	end

	v17.ref = v12
	return createElement("Frame", v17, {
		SlotTray = Roact.createElement(slotTray, {
			defaultSelectedSlotIndex = v7,
			width = state,
			slots = v15,
			onChange = props.onActivated,
			onInputBegan = v13,
			onInputEnded = v14,
			darken = itemsListFocused,
			onFocusChanged = props.onFocusChanged,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			scrollingFrameRef = forwardRef
		})
	})
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(EquipSlots, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
