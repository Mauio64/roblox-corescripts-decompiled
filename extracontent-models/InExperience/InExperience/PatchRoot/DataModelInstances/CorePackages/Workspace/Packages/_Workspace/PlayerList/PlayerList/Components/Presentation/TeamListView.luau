local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)
local View = require(ParentParentParent.Foundation).View

require(ParentParentParent.LeaderboardStore)

local TeamEntryView = require(ParentParent.Components.Presentation.TeamEntryView)
local EntryView = require(ParentParent.Components.Presentation.EntryView)

require(ParentParent.Common.computeStatColumns)

local v9 = Signals.createSignal({})
local v10 = Signals.createSignal(0)

local function TeamListView(t1: {[any]: any}) -- line: 27
	-- upvalues: SignalsReact (copy), v9 (copy), v10 (copy), React (copy), TeamEntryView (copy), EntryView (copy), View (copy)
	local teamEntry = t1.teamEntry
	local players = teamEntry.players
	local v15 = SignalsReact.useSignalState(if not players then v9 else players.getAllData)
	local v16 = SignalsReact.useSignalState(if not players then v10 else players.getCount)
	local v17 = SignalsReact.useSignalBinding(teamEntry.order)
	local v18 = t1.isNeutral and (not t1.hasNonNeutralTeams or v16 == 0)

	if t1.isNeutral and v16 == 0 then
		return nil
	end

	local t2 = {}

	if not v18 then
		t2.TeamHeader = React.createElement(TeamEntryView, {
			name = teamEntry.name,
			color = teamEntry.color,
			order = teamEntry.order,
			teamStats = teamEntry.stats,
			statColumns = t1.statColumns,
			statWidth = t1.statWidth,
			rowHeight = t1.columnHeaderHeight
		})
	end

	if players then
		local v20 = teamEntry.order(false)

		for k in pairs(v15) do
			t2[`Player_{ k.UserId }`] = React.createElement(EntryView, {
				player = k,
				leaderboardStore = t1.leaderboardStore,
				statColumns = t1.statColumns,
				statWidth = t1.statWidth,
				teamOrder = v20,
				onActivated = t1.onActivated,
				rowHeight = t1.rowHeight,
				isCurrentUser = t1.localPlayer ~= nil and k == t1.localPlayer
			})
		end
	end

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = v17
	}, t2)
end

return React.memo(TeamListView)
