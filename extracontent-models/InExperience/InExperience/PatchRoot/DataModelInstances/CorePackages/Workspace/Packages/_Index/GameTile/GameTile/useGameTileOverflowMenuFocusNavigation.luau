local GuiService = game:GetService("GuiService")

local parent = script:FindFirstAncestor("GameTile").Parent

local AppBlox = require(parent.AppBlox)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Responsive = require(parent.Responsive)
local SharedFlags = require(parent.SharedFlags)

local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local GetInputModeStore = Responsive.GetInputModeStore

local FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry
local FFlagLuaAppGameTileOverflowMenuFocusTransferFix = SharedFlags.FFlagLuaAppGameTileOverflowMenuFocusTransferFix

local openQuickMenusByButtonStart = {
	[Enum.KeyCode.ButtonStart] = FocusNavigationEventNameEnum.OpenQuickMenu
}

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useGameTileOverflowMenuFocusNavigation(p: string, current: boolean?, p2, callback)
	local state, setState = React.useState(nil)
	local ref = React.useRef(false)

	local useMemo = React.useMemo
	local function fn()
		return {
			[FocusNavigationEventNameEnum.OpenQuickMenu] = {
				handler = InputHandlers.onRelease(function()
					getOverflowMenuSignalStore().openMenu(p)

					if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry and callback then
						callback(false)
					end
				end)
			}
		}, {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function()
					getOverflowMenuSignalStore().closeMenu(p)

					if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry and callback then
						callback(true)
					end
				end)
			}
		}
	end

	local v

	if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
		v = callback
	end

	local v2, v3 = useMemo(fn, { p, v })

	local v4 = ReactFocusNavigation.useEventMap(openQuickMenusByButtonStart)
	local v5 = ReactFocusNavigation.useEventMap(navigateBacks)

	local v6 = ReactFocusNavigation.useEventHandlerMap(v2, v4)

	local v7 = ReactFocusNavigation.useEventHandlerMap(v3, v5)

	React.useEffect(function()
		if v6 and p2 then
			v6(p2.current)
		end
	end, { v6, p2 })

	React.useEffect(function()
		if v7 then
			v7(state)
		end
	end, { v7, state })

	React.useEffect(function()
		if GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Directional and current and state then
			GuiService:Select(state)
		end
	end, { state })

	local ref2 = React.useRef(current)
	local useEffect = React.useEffect
	local function fn2()
		if ref2.current ~= current then
			ref2.current = current

			if not (current or ref.current) then
				local overflowMenuSignalStore = getOverflowMenuSignalStore()

				if not overflowMenuSignalStore.getIsMenuOpen(p) then
					overflowMenuSignalStore.closeMenu(p)
					return
				end

				local selectedCoreObject = GuiService.SelectedCoreObject

				local v8 = FFlagLuaAppGameTileOverflowMenuFocusTransferFix
					and state
					and selectedCoreObject
					and selectedCoreObject:IsDescendantOf(state)

				if
					p2
					and p2.current
					and selectedCoreObject
					and not selectedCoreObject:IsDescendantOf(p2.current)
					and not (FFlagLuaAppGameTileOverflowMenuFocusTransferFix and v8)
				then
					overflowMenuSignalStore.closeMenu(p)
				end
			end
		end
	end

	local v8

	if FFlagLuaAppGameTileOverflowMenuFocusTransferFix then
		v8 = state
	end

	useEffect(fn2, { current, p, p2, v8 })

	local v9 = React.useCallback(function()
		if state and GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(state) then
			ref.current = true
		elseif ref.current ~= false then
			ref.current = false
			getOverflowMenuSignalStore().closeMenu(p)
		end
	end, { state, p })

	React.useLayoutEffect(function()
		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(v9)
		v9()

		return function()
			if selectedCoreObjectChangedConnection then
				selectedCoreObjectChangedConnection:Disconnect()
			end
		end
	end, { v9 })

	return setState
end

return useGameTileOverflowMenuFocusNavigation
