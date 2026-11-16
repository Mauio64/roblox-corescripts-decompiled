local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Constants = require(script.Parent.Constants)
local TraversalTelemetry = require(script.Parent.TraversalTelemetry)

local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local Menu = Foundation.Menu
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization

local function formatTags(historyButtonTags) -- 1 equivalent call inferred from this helper
	if typeof(historyButtonTags) == "table" then
		return historyButtonTags
	end

	return { [historyButtonTags] = true }
end

local function setMenuSelection(p, p2, p3)
	if not (p and p.current) then
		return
	end

	if p3 == PopoverSide.Top then
		p.current.NextSelectionUp = p2
	elseif p3 == PopoverSide.Bottom then
		p.current.NextSelectionDown = p2
	end
end

local function HistoryMenu(props, p)
	local v

	if props.idleButtonStateIsDown == nil then
		v = Constants.DEFAULT_CHEVRON_BUTTON_STATE
	else
		v = props.idleButtonStateIsDown
	end

	local state, setState = React.useState(false)
	local v2

	if state then
		v2 = not v or not state and v
	else
		v2 = not state and v
	end

	local v3 = useLocalization({ history = "CoreScripts.TopBar.Traversal.History" })

	local ref = React.useRef(nil)

	local ref2 = React.useCallback(function(p2)
		local ref2 = ref
		local menuSide = props.menuSide

		if ref2 then
			if not ref2.current then
				return
			end

			if menuSide == PopoverSide.Top then
				ref2.current.NextSelectionUp = p2
			elseif menuSide == PopoverSide.Bottom then
				ref2.current.NextSelectionDown = p2
			end
		end
	end, { props.menuSide })

	local tag = React.useMemo(function()
		local v4

		if props.historyButtonTags then
			v4 = formatTags(props.historyButtonTags) -- inferred equivalent call
		else
			v4 = {}
		end

		return Cryo.Dictionary.join({
			["row auto-xy align-y-center align-x-center radius-medium"] = true
		}, v4)
	end, { props.historyButtonTags })

	local v4 = React.useCallback(function()
		if props.onMenuToggled then
			props.onMenuToggled(not state)
		end

		setState(not state)
	end, { state, props.onMenuToggled })

	local onPressedOutside = React.useCallback(function()
		setState(false)

		if props.onMenuToggled then
			props.onMenuToggled(false)
		end
	end, {})
	React.useEffect(function()
		if not props.closeMenuConn then
			return
		end

		local v5 = props.closeMenuConn(onPressedOutside)
		return function()
			for _, connection in v5 do
				connection:Disconnect()
			end
		end
	end, { props.closeMenuConn, onPressedOutside })

	local onActivated = React.useCallback(function(p2: number)
		TraversalTelemetry.sendHistoryMenuItemClick({
			integration_id = "history_dropdown",
			event_type = "click",
			destination_universe_id = tostring(p2)
		})

		onPressedOutside()

		if not props.onMenuItemSelected then
			return
		end

		props.onMenuItemSelected(p2)
	end, { onPressedOutside, props.onMenuItemSelected })

	local onActivated2 = React.useCallback(function()
		TraversalTelemetry.sendHistoryMenuHistoryClick({
			integration_id = "history_landing",
			event_type = "click"
		})

		onPressedOutside()
		props.onHistorySelected()
	end, { onPressedOutside, props.onHistorySelected })

	local items = React.useMemo(function()
		local mapped = Cryo.List.map(props.historyItems, function(data)
			return { id = data.universeId, text = data.text, icon = data.icon }
		end)

		local v5 = {
			{
				id = "history",
				text = v3.history,
				icon = IconName.ClockSpinReverse,
				onActivated = onActivated2
			}
		}
		return (Cryo.List.join(mapped, v5))
	end, { props.historyItems })

	local createElement = React.createElement

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local name

	if v2 then
		name = IconName.ChevronLargeDown
	else
		name = IconName.ChevronLargeUp
	end

	local children = {
		ChevronButton = createElement2(View, {
			tag = tag,
			onActivated = function()
				TraversalTelemetry.sendHistoryMenuButtonActionEvent({
					integration_id = "history_chevron",
					event_type = state and "close" or "open"
				})

				v4()
			end,
			ref = ref,
			testId = "--chevron-button"
		}, {
			Chevron = createElement3(Icon, { name = name })
		}),
		Menu = 0
	}

	local createElement4 = React.createElement
	local v5 = {
		align = PopoverAlign.Start,
		anchorRef = p or ref,
		isOpen = state,
		items = items,
		onActivated = onActivated,
		onPressedOutside = onPressedOutside,
		side = props.menuSide,
		size = props.menuSize,
		width = 0,
		ref = 0
	}
	local width

	if p and p.current then
		width = UDim.new(0, p.current.AbsoluteSize.X)
	end

	v5.width = width
	v5.ref = ref2
	children.Menu = createElement4(Menu, v5)
	return createElement(View, { tag = "auto-xy" }, children)
end

return React.memo(React.forwardRef(HistoryMenu))
