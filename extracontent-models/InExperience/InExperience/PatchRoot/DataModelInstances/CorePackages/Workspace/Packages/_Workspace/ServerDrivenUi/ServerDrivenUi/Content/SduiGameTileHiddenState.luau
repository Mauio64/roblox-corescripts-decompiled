local GuiService = game:GetService("GuiService")

local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local View = Foundation.View
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local function SduiGameTileHiddenState(props)
	local ref = React.useRef(nil)
	local v = useFocusGuiObject()

	local onActivated = React.useCallback(function()
		if not props.onUndoActivated then
			return
		end

		local v2 = GuiService.SelectedCoreObject == ref.current

		props.onUndoActivated()

		if v2 then
			task.defer(function()
				local current

				if props.parentRef then
					current = props.parentRef.current
				end

				if current then
					v(current)
				end
			end)
		end
	end, { v, props.onUndoActivated, props.parentRef })
	local undoButton

	if props.undoButtonComponent and props.onUndoActivated then
		undoButton = React.createElement(getSduiComponentWrapper(props.undoButtonComponent), {
			componentConfig = props.undoButtonComponent,
			debugName = "SduiGameTileHiddenState.UndoButton",
			extraLocalProps = {
				buttonRef = ref,
				onActivated = onActivated,
				testId = "--sdui-game-tile-undo"
			},
			sduiContext = props.sduiContext
		})
	end

	return React.createElement(View, {
		tag = props.containerTag or "col align-x-center align-y-center gap-small size-full padding-medium radius-medium bg-surface-100"
	}, { Message = props.messageComponent, UndoButton = undoButton })
end

return React.memo(SduiGameTileHiddenState)
