local GuiService = game:GetService("GuiService")

local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppBlox")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/ReactFocusNavigation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")

local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local getInputModeStore = Responsive.GetInputModeStore

local fFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry
local fFlagLuaAppGameTileOverflowMenuFocusTransferFix = SharedFlags.FFlagLuaAppGameTileOverflowMenuFocusTransferFix

local openQuickMenusByButtonStart = {
	[Enum.KeyCode.ButtonStart] = focusNavigationEventNameEnum.OpenQuickMenu
}

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useGameTileOverflowMenuFocusNavigation(p2, current, p3, callback)
	local state, setState = React.useState(nil)
	local ref = React.useRef(false)

	local function fn()
		return {
			[focusNavigationEventNameEnum.OpenQuickMenu] = {
				handler = InputHandlers.onRelease(function()
					getOverflowMenuSignalStore().openMenu(p2)

					if fFlagLuaAppFixExplicitFeedbackConsoleTelemetry and callback then
						callback(false)
					end
				end)
			}
		}, {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function()
					getOverflowMenuSignalStore().closeMenu(p2)

					if fFlagLuaAppFixExplicitFeedbackConsoleTelemetry and callback then
						callback(true)
					end
				end)
			}
		}
	end

	local v7, v8 = React.useMemo(fn, {
		p2,
		if fFlagLuaAppFixExplicitFeedbackConsoleTelemetry then callback else nil
	})

	local v9 = ReactFocusNavigation.useEventMap(openQuickMenusByButtonStart)
	local v10 = ReactFocusNavigation.useEventMap(navigateBacks)

	local v11 = ReactFocusNavigation.useEventHandlerMap(v7, v9)

	local v12 = ReactFocusNavigation.useEventHandlerMap(v8, v10)

	React.useEffect(function()
		if v11 and p3 then
			v11(p3.current)
		end
	end, { v11, p3 })

	React.useEffect(function()
		if v12 then
			v12(state)
		end
	end, { v12, state })

	React.useEffect(function()
		if
			getInputModeStore(false).getLastInputType(false) == Responsive.Input.Directional
			and current
			and state
		then
			GuiService:Select(state)
		end
	end, { state })

	local ref2 = React.useRef(current)

	local function fn2()
		if ref2.current ~= current then
			ref2.current = current

			if not (current or ref.current) then
				local overflowMenuSignalStore = getOverflowMenuSignalStore()

				if not overflowMenuSignalStore.getIsMenuOpen(p2) then
					overflowMenuSignalStore.closeMenu(p2)
					return
				end

				local selectedCoreObject = GuiService.SelectedCoreObject

				local v13 = fFlagLuaAppGameTileOverflowMenuFocusTransferFix
					and state
					and selectedCoreObject
					and selectedCoreObject:IsDescendantOf(state)

				if
					p3
					and p3.current
					and selectedCoreObject
					and not selectedCoreObject:IsDescendantOf(p3.current)
					and not (fFlagLuaAppGameTileOverflowMenuFocusTransferFix and v13)
				then
					overflowMenuSignalStore.closeMenu(p2)
				end
			end
		end
	end

	React.useEffect(fn2, {
		current,
		p2,
		p3,
		if fFlagLuaAppGameTileOverflowMenuFocusTransferFix then state else nil
	})

	local v15 = React.useCallback(function()
		if
			state
			and GuiService.SelectedCoreObject
			and GuiService.SelectedCoreObject:IsDescendantOf(state)
		then
			ref.current = true
		elseif ref.current ~= false then
			ref.current = false
			getOverflowMenuSignalStore().closeMenu(p2)
		end
	end, { state, p2 })

	React.useLayoutEffect(function()
		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(v15)
		v15()

		return function()
			if selectedCoreObjectChangedConnection then
				selectedCoreObjectChangedConnection:Disconnect()
			end
		end
	end, { v15 })

	return setState
end

return useGameTileOverflowMenuFocusNavigation
