local GuiService = game:GetService("GuiService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ReactFocusNavigation")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local view = Foundation.View
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local function SduiGameTileHiddenState(props)
	local ref = React.useRef(nil)
	local v5 = useFocusGuiObject()

	local v6 = React.useCallback(function()
		if not props.onUndoActivated then
			return
		end

		local v7 = GuiService.SelectedCoreObject == ref.current

		props.onUndoActivated()

		if v7 then
			task.defer(function()
				local current = if props.parentRef then props.parentRef.current else nil

				if current then
					v5(current)
				end
			end)
		end
	end, { v5, props.onUndoActivated, props.parentRef })

	local v7 = if props.undoButtonComponent and props.onUndoActivated then React.createElement(
		getSduiComponentWrapper(props.undoButtonComponent),
		{
			componentConfig = props.undoButtonComponent,
			debugName = "SduiGameTileHiddenState.UndoButton",
			extraLocalProps = {
				buttonRef = ref,
				onActivated = v6,
				testId = "--sdui-game-tile-undo"
			},
			sduiContext = props.sduiContext
		}
	) else nil

	return React.createElement(view, {
		tag = props.containerTag or "col align-x-center align-y-center gap-small size-full padding-medium radius-medium bg-surface-100"
	}, { Message = props.messageComponent, UndoButton = v7 })
end

return React.memo(SduiGameTileHiddenState)
