local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Responsive")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local FFlagSduiContentRowStateLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Flags/FFlagSduiContentRowStateLayer")
local FFlagSDUIContentRowSelectable = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Flags/FFlagSDUIContentRowSelectable")
local fFlagSduiContentRowTrailingHover = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiContentRowTrailingHover

local FFlagSduiContentRowTrailingHoverPointerOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Flags/FFlagSduiContentRowTrailingHoverPointerOnly")

local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local cursorType = Foundation.Enums.CursorType
local useCursor = Foundation.Hooks.useCursor

local function SduiContentRow(props)
	local v5, v6

	if fFlagSduiContentRowTrailingHover then
		local v7 = if FFlagSduiContentRowTrailingHoverPointerOnly then Responsive.useLastInput() == Responsive.Input.Pointer else nil

		local state, setState = React.useState(false)
		v5 = React.useCallback(function(p2)
			setState(p2 == controlState.Hover or p2 == controlState.Pressed)
		end, {})

		if props.trailingHover == nil or not state or FFlagSduiContentRowTrailingHoverPointerOnly and not v7 then
			v6 = props.trailing
		else
			v6 = props.trailingHover
		end
	end

	local v7 = FFlagSDUIContentRowSelectable and props.selectable == true
	local v8 = if FFlagSDUIContentRowSelectable then useCursor(cursorType.RoundedRect) else nil

	local createElement = React.createElement
	local v10 = {
		tag = not props.tag and "row auto-y gap-large" or props.tag,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		ZIndex = props.zIndex,
		Active = props.onActivated ~= nil,
		onActivated = props.onActivated,
		onStateChanged = 0,
		selection = 0,
		stateLayer = 0,
		testId = 0
	}

	if not fFlagSduiContentRowTrailingHover or props.trailingHover == nil then
		v5 = nil
	end

	v10.onStateChanged = v5

	if not v7 then
		v8 = nil
	end

	v10.selection = { Selectable = v7, SelectionImageObject = v8 }

	local v13 = if FFlagSduiContentRowStateLayer then props.stateLayerAffordance or Foundation.Enums.StateLayerAffordance.None else Foundation.Enums.StateLayerAffordance.None
	v10.stateLayer = { affordance = v13 }

	v10.testId = props.testId

	local v15 = if props.leading then React.createElement(view, {
		LayoutOrder = 1,
		tag = props.leadingTag or "col auto-xy"
	}, props.leading) else nil

	local v16 = if props.content then React.createElement(view, {
		LayoutOrder = 2,
		tag = props.contentTag or "col fill gap-small auto-xy"
	}, props.content) else nil

	local v17 = if fFlagSduiContentRowTrailingHover then v6 else props.trailing
	local v18

	if v17 then
		local createElement2 = React.createElement
		local v20 = {
			LayoutOrder = 3,
			tag = props.trailingTag or "col auto-xy"
		}

		if not fFlagSduiContentRowTrailingHover then
			v6 = props.trailing
		end

		v18 = createElement2(view, v20, v6)
	end

	return createElement(view, v10, {
		LeadingColumn = v15,
		ContentColumn = v16,
		TrailingColumn = v18
	})
end

return React.memo(SduiContentRow)
