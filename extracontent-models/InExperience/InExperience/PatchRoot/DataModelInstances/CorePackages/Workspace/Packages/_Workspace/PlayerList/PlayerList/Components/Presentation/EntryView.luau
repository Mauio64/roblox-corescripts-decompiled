local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Signals = require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)

require(parent2.LeaderboardStore)

local StatCell = require(parent.Components.Presentation.StatCell)
local LeaderboardRowShell = require(parent.Components.Presentation.LeaderboardRowShell)
local PeopleCell = require(parent.Components.Presentation.PeopleCell)
local resolveDisplayName = require(parent.Common.resolveDisplayName)
local Constants = require(parent.Common.Constants)
require(parent.Common.computeStatColumns)

local TEAM_LAYOUT_MULTIPLIER = Constants.TEAM_LAYOUT_MULTIPLIER

local signal = Signals.createSignal({})

local selection = { Selectable = true }

local function buildEntryViewElement(props, p, layoutOrder, onActivated, rowRef, selection2)
	local rowHeight = props.rowHeight
	local statColumns = props.statColumns or {}

	local children = {
		PeopleCell = React.createElement(PeopleCell, {
			displayName = resolveDisplayName(props.player),
			player = props.player,
			layoutOrder = 1,
			truncate = true
		})
	}

	for i, statColumn in ipairs(statColumns) do
		local playerStat

		if p then
			playerStat = p.stats.getData(statColumn.name, false)
		end

		children[`Stat_{statColumn.name}`] = React.createElement(StatCell, {
			statName = statColumn.name,
			playerStat = playerStat,
			statWidth = props.statWidth,
			rowHeight = rowHeight,
			layoutOrder = i + 1
		})
	end

	return React.createElement(LeaderboardRowShell, {
		rowHeight = rowHeight,
		layoutOrder = layoutOrder,
		isHighlighted = props.isCurrentUser == true,
		showDivider = true,
		onActivated = onActivated,
		rowRef = rowRef,
		selection = selection2
	}, children)
end

local function useEntryViewCore(data)
	local ref = React.useRef(nil)

	local v = React.useCallback(function()
		if data.onActivated then
			local v

			if ref.current then
				v = ref.current.AbsolutePosition
			end

			data.onActivated(data.player, v, ref.current)
		end
	end, { data.player, data.onActivated })

	local playerEntry = data.leaderboardStore.getPlayerEntry(data.player, false)

	local useSignalState = SignalsReact.useSignalState
	local v2

	if playerEntry then
		v2 = playerEntry.stats.getAllData
	else
		v2 = signal
	end

	useSignalState(v2)

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if playerEntry and data.teamOrder ~= nil then
				return data.teamOrder * TEAM_LAYOUT_MULTIPLIER + playerEntry.order(p)
			end

			return data.layoutOrder or 0
		end)
	end, { playerEntry, data.teamOrder, data.layoutOrder })
	return ref, playerEntry, SignalsReact.useSignalBinding(v3), v
end

local function EntryView(p)
	local v, v2, layoutOrder, onActivated = useEntryViewCore(p)

	local rowRefForward = p.rowRefForward
	return buildEntryViewElement(p, v2, layoutOrder, onActivated, React.useCallback(function(current)
		v.current = current

		if rowRefForward then
			if typeof(rowRefForward) == "function" then
				rowRefForward(current)
			else
				rowRefForward.current = current
			end
		end
	end, { v, rowRefForward }), selection)
end

return React.memo(EntryView)
