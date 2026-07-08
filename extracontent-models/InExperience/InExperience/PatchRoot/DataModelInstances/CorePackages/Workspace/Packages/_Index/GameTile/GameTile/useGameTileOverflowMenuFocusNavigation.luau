local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("GameTile").Parent
local AppBlox = require(Parent.AppBlox)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local InputHandlers = require(Parent.InputHandlers)
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local Responsive = require(Parent.Responsive)
local SharedFlags = require(Parent.SharedFlags)
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local GetInputModeStore = Responsive.GetInputModeStore
local FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry
local v14 = game:DefineFastFlag("LuaAppGameTileOverflowMenuSelectionCloseFix", false)
local t1 = {
	[Enum.KeyCode.ButtonStart] = FocusNavigationEventNameEnum.OpenQuickMenu
}
local t2 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useGameTileOverflowMenuFocusNavigation(s1: string, b1: boolean?, p1, p2: ((...any) -> ...any)?) -- line: 33
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), getOverflowMenuSignalStore (copy), FFlagLuaAppFixExplicitFeedbackConsoleTelemetry (copy), ReactFocusNavigation (copy), t1 (copy), t2 (copy), GetInputModeStore (copy), Responsive (copy), GuiService (copy), v14 (copy)
	local v22, v23 = React.useState(nil)
	local v24 = React.useRef(false)
	local v25, v26 = React.useMemo(function() -- line: 42
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), getOverflowMenuSignalStore (copy), s1 (copy), FFlagLuaAppFixExplicitFeedbackConsoleTelemetry (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.OpenQuickMenu] = {
				handler = InputHandlers.onRelease(function() -- line: 45
					-- upvalues: getOverflowMenuSignalStore (copy), s1 (copy), FFlagLuaAppFixExplicitFeedbackConsoleTelemetry (copy), p2 (copy)
					getOverflowMenuSignalStore().openMenu(s1)

					if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry and p2 then
						p2(false)
					end
				end)
			}
		}, {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function() -- line: 55
					-- upvalues: getOverflowMenuSignalStore (copy), s1 (copy), FFlagLuaAppFixExplicitFeedbackConsoleTelemetry (copy), p2 (copy)
					getOverflowMenuSignalStore().closeMenu(s1)

					if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry and p2 then
						p2(true)
					end
				end)
			}
		}
	end, {
		s1,
		if not FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then nil else p2
	})
	local v27 = ReactFocusNavigation.useEventMap(t1)
	local v28 = ReactFocusNavigation.useEventMap(t2)
	local v29 = ReactFocusNavigation.useEventHandlerMap(v25, v27)
	local v30 = ReactFocusNavigation.useEventHandlerMap(v26, v28)

	React.useEffect(function() -- line: 72
		-- upvalues: v29 (copy), p1 (copy)
		if v29 and p1 then
			v29(p1.current)
		end
	end, {
		v29,
		p1
	})
	React.useEffect(function() -- line: 78
		-- upvalues: v30 (copy), v22 (copy)
		if v30 then
			v30(v22)
		end
	end, {
		v30,
		v22
	})
	React.useEffect(function() -- line: 85
		-- upvalues: GetInputModeStore (copy), Responsive (copy), b1 (copy), v22 (copy), GuiService (copy)
		if GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Directional and (b1 and v22) then
			GuiService:Select(v22)
		end
	end, { v22 })

	local v31 = React.useRef(b1)

	React.useEffect(function() -- line: 94
		-- upvalues: v31 (copy), b1 (copy), v24 (copy), v14 (copy), getOverflowMenuSignalStore (copy), s1 (copy), GuiService (copy), p1 (copy)
		if v31.current ~= b1 then
			v31.current = b1

			if not b1 and not v24.current then
				if v14 then
					local v33 = getOverflowMenuSignalStore()

					if not v33.getIsMenuOpen(s1) then
						v33.closeMenu(s1)

						return
					end

					local SelectedCoreObject = GuiService.SelectedCoreObject

					if p1 and p1.current and SelectedCoreObject and not SelectedCoreObject:IsDescendantOf(p1.current) then
						v33.closeMenu(s1)

						return
					end
				else
					getOverflowMenuSignalStore().closeMenu(s1)
				end
			end
		end
	end, {
		b1,
		if not v14 then nil else s1,
		if not v14 then nil else p1
	})

	local v32 = React.useCallback(function() -- line: 128
		-- upvalues: v22 (copy), GuiService (copy), v24 (copy), getOverflowMenuSignalStore (copy), s1 (copy)
		if v22 and (GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(v22)) then
			v24.current = true

			return
		end

		if v24.current ~= false then
			v24.current = false
			getOverflowMenuSignalStore().closeMenu(s1)
		end
	end, {
		v22,
		s1
	})

	React.useLayoutEffect(function() -- line: 139
		-- upvalues: GuiService (copy), v32 (copy)
		local connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(v32)

		v32()

		return function() -- line: 143
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v32 })

	return v23
end

return useGameTileOverflowMenuFocusNavigation
