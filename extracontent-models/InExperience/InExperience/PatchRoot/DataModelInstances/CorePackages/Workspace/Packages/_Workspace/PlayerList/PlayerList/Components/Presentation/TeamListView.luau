local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Signals = require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)
local View = Foundation.View

require(parent2.LeaderboardStore)

local TeamEntryView = require(parent.Components.Presentation.TeamEntryView)
local EntryView = require(parent.Components.Presentation.EntryView)
require(parent.Common.computeStatColumns)

local signal = Signals.createSignal({})
local signal2 = Signals.createSignal(0)

local function TeamListView(props)
	local teamEntry = props.teamEntry
	local players = teamEntry.players

	local useSignalState = SignalsReact.useSignalState
	local v = if players then players.getAllData else signal
	local v2 = useSignalState(v)

	local useSignalState2 = SignalsReact.useSignalState
	local v3 = if players then players.getCount else signal2
	local v4 = useSignalState2(v3)
	local layoutOrder = SignalsReact.useSignalBinding(teamEntry.order)

	local v5 = (not props.isNeutral or props.hasNonNeutralTeams and v4 ~= 0) and true or false

	if props.isNeutral and v4 == 0 then
		return nil
	end

	local children = {}

	if v5 then
		children.TeamHeader = React.createElement(TeamEntryView, {
			name = teamEntry.name,
			color = teamEntry.color,
			order = teamEntry.order,
			teamStats = teamEntry.stats,
			statColumns = props.statColumns,
			statWidth = props.statWidth,
			rowHeight = props.columnHeaderHeight
		})
	end

	if players then
		local order = teamEntry.order(false)
		local v6 = 1e999
		local userId = nil

		for k in pairs(v2) do
			local playerEntry = props.leaderboardStore.getPlayerEntry(k, false)
			local v7 = not playerEntry and 0 or playerEntry.order(false)
			local v8

			if v7 == v6 and userId ~= nil then
				v8 = k.UserId < userId
			else
				v8 = false
			end

			if not (v7 < v6 or v8) then
				continue
			end

			userId = k.UserId
			v6 = v7
		end

		for k in pairs(v2) do
			local formatted = `Player_{k.UserId}`
			local createElement = React.createElement
			local v7 = {
				player = k,
				leaderboardStore = props.leaderboardStore,
				statColumns = props.statColumns,
				statWidth = props.statWidth,
				teamOrder = order,
				onActivated = props.onActivated,
				rowHeight = props.rowHeight,
				isCurrentUser = props.localPlayer ~= nil and k == props.localPlayer,
				rowRefForward = 0
			}
			local rowRefForward

			if k.UserId == userId then
				rowRefForward = props.firstRowRefForward
			end

			v7.rowRefForward = rowRefForward
			children[formatted] = createElement(EntryView, v7)
		end
	end

	return React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = layoutOrder }, children)
end

return React.memo(TeamListView)
