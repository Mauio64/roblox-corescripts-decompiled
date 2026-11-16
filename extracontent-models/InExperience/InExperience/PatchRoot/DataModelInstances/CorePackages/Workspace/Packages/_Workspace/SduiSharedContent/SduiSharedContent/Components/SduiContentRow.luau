local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
require(parent.SduiCompat)

local FFlagSduiContentRowStateLayer = require(SduiSharedContent.Flags.FFlagSduiContentRowStateLayer)
local FFlagSDUIContentRowSelectable = require(SduiSharedContent.Flags.FFlagSDUIContentRowSelectable)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiContentRowTrailingHover = SharedFlags.FFlagSduiContentRowTrailingHover

local FFlagSduiContentRowTrailingHoverPointerOnly = require(SduiSharedContent.Flags.FFlagSduiContentRowTrailingHoverPointerOnly)

local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local CursorType = Foundation.Enums.CursorType
local useCursor = Foundation.Hooks.useCursor

local function SduiContentRow(props)
	local onStateChanged, v

	if FFlagSduiContentRowTrailingHover then
		local v2

		if FFlagSduiContentRowTrailingHoverPointerOnly then
			v2 = Responsive.useLastInput() == Responsive.Input.Pointer
		end

		local state, setState = React.useState(false)
		onStateChanged = React.useCallback(function(p)
			setState(p == ControlState.Hover or p == ControlState.Pressed)
		end, {})

		if props.trailingHover == nil or not state or FFlagSduiContentRowTrailingHoverPointerOnly and not v2 then
			v = props.trailing
		else
			v = props.trailingHover
		end
	end

	local selectable = FFlagSDUIContentRowSelectable and props.selectable == true
	local selectionImageObject

	if FFlagSDUIContentRowSelectable then
		selectionImageObject = useCursor(CursorType.RoundedRect)
	end

	local createElement = React.createElement
	local v2 = {
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

	if not FFlagSduiContentRowTrailingHover or props.trailingHover == nil then
		onStateChanged = nil
	end

	v2.onStateChanged = onStateChanged

	if not selectable then
		selectionImageObject = nil
	end

	v2.selection = { Selectable = selectable, SelectionImageObject = selectionImageObject }
	local affordance

	if FFlagSduiContentRowStateLayer then
		affordance = props.stateLayerAffordance or Foundation.Enums.StateLayerAffordance.None
	else
		affordance = Foundation.Enums.StateLayerAffordance.None
	end

	v2.stateLayer = { affordance = affordance }

	v2.testId = props.testId
	local leadingColumn

	if props.leading then
		leadingColumn = React.createElement(View, {
			LayoutOrder = 1,
			tag = props.leadingTag or "col auto-xy"
		}, props.leading)
	end

	local contentColumn

	if props.content then
		contentColumn = React.createElement(View, {
			LayoutOrder = 2,
			tag = props.contentTag or "col fill gap-small auto-xy"
		}, props.content)
	end

	local v3

	if FFlagSduiContentRowTrailingHover then
		v3 = v
	else
		v3 = props.trailing
	end

	local trailingColumn

	if v3 then
		local createElement2 = React.createElement
		local v4 = {
			LayoutOrder = 3,
			tag = props.trailingTag or "col auto-xy"
		}

		if not FFlagSduiContentRowTrailingHover then
			v = props.trailing
		end

		trailingColumn = createElement2(View, v4, v)
	end

	return createElement(View, v2, {
		LeadingColumn = leadingColumn,
		ContentColumn = contentColumn,
		TrailingColumn = trailingColumn
	})
end

return React.memo(SduiContentRow)
