local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/Constants")
local TraversalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TraversalTelemetry")

local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local menu = Foundation.Menu
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local view = Foundation.View
local useLocalization = Localization.Hooks.useLocalization

local function formatTags(p2)
	if typeof(p2) == "table" then
		return p2
	end

	return { [p2] = true }
end

local function setMenuSelection(p2, p3, p4)
	if not (p2 and p2.current) then
		return
	end

	if p4 == popoverSide.Top then
		p2.current.NextSelectionUp = p3
	elseif p4 == popoverSide.Bottom then
		p2.current.NextSelectionDown = p3
	end
end

local function HistoryMenu(props, p2)
	local v5

	if props.idleButtonStateIsDown == nil then
		v5 = Constants.DEFAULT_CHEVRON_BUTTON_STATE
	else
		v5 = props.idleButtonStateIsDown
	end

	local state, setState = React.useState(false)
	local v6 = if state then not v5 or not state and v5 else not state and v5
	local v7 = useLocalization({ history = "CoreScripts.TopBar.Traversal.History" })

	local ref = React.useRef(nil)

	local v8 = React.useCallback(function(p3)
		local v9 = ref
		local menuSide = props.menuSide

		if v9 then
			if not v9.current then
				return
			end

			if menuSide == popoverSide.Top then
				v9.current.NextSelectionUp = p3
			elseif menuSide == popoverSide.Bottom then
				v9.current.NextSelectionDown = p3
			end
		end
	end, { props.menuSide })

	local v9 = React.useMemo(function()
		local v10

		if props.historyButtonTags then
			local historyButtonTags = props.historyButtonTags
			v10 = typeof(historyButtonTags) ~= "table" and {
					[historyButtonTags] = true
				}
				or historyButtonTags
		else
			v10 = {}
		end

		return Cryo.Dictionary.join(
			{ ["row auto-xy align-y-center align-x-center radius-medium"] = true },
			v10
		)
	end, { props.historyButtonTags })

	local v10 = React.useCallback(function()
		if props.onMenuToggled then
			props.onMenuToggled(not state)
		end

		setState(not state)
	end, { state, props.onMenuToggled })

	local v11 = React.useCallback(function()
		setState(false)

		if props.onMenuToggled then
			props.onMenuToggled(false)
		end
	end, {})
	React.useEffect(function()
		if not props.closeMenuConn then
			return
		end

		local v12 = props.closeMenuConn(v11)
		return function()
			for k, connection in v12 do
				connection:Disconnect()
			end
		end
	end, { props.closeMenuConn, v11 })

	local v12 = React.useCallback(function(p3)
		TraversalTelemetry.sendHistoryMenuItemClick({
			integration_id = "history_dropdown",
			event_type = "click",
			destination_universe_id = tostring(p3)
		})

		v11()

		if not props.onMenuItemSelected then
			return
		end

		props.onMenuItemSelected(p3)
	end, { v11, props.onMenuItemSelected })

	local v13 = React.useCallback(function()
		TraversalTelemetry.sendHistoryMenuHistoryClick({
			integration_id = "history_landing",
			event_type = "click"
		})

		v11()
		props.onHistorySelected()
	end, { v11, props.onHistorySelected })

	local v14 = React.useMemo(function()
		local mapped = Cryo.List.map(props.historyItems, function(data)
			return { id = data.universeId, text = data.text, icon = data.icon }
		end)

		local v15 = {
			{
				id = "history",
				text = v7.history,
				icon = iconName.ClockSpinReverse,
				onActivated = v13
			}
		}
		return (Cryo.List.join(mapped, v15))
	end, { props.historyItems })

	local createElement = React.createElement

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v22 = if v6 then iconName.ChevronLargeDown else iconName.ChevronLargeUp
	local children = {
		ChevronButton = createElement2(view, {
			tag = v9,
			onActivated = function()
				TraversalTelemetry.sendHistoryMenuButtonActionEvent({
					integration_id = "history_chevron",
					event_type = state and "close" or "open"
				})

				v10()
			end,
			ref = ref,
			testId = "--chevron-button"
		}, {
			Chevron = createElement3(icon, { name = v22 })
		}),
		Menu = 0
	}

	local createElement4 = React.createElement
	local v24 = {
		align = popoverAlign.Start,
		anchorRef = p2 or ref,
		isOpen = state,
		items = v14,
		onActivated = v12,
		onPressedOutside = v11,
		side = props.menuSide,
		size = props.menuSize,
		width = 0,
		ref = 0
	}
	local v25 = if p2 and p2.current then UDim.new(0, p2.current.AbsoluteSize.X) else nil
	v24.width = v25
	v24.ref = v8
	children.Menu = createElement4(menu, v24)
	return createElement(view, { tag = "auto-xy" }, children)
end

return React.memo(React.forwardRef(HistoryMenu))
