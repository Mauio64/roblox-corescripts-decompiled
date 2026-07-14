local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)

require(ParentParentParent.LeaderboardStore)

local StatCell = require(ParentParent.Components.Presentation.StatCell)
local LeaderboardRowShell = require(ParentParent.Components.Presentation.LeaderboardRowShell)
local PeopleCell = require(ParentParent.Components.Presentation.PeopleCell)
local resolveDisplayName = require(ParentParent.Common.resolveDisplayName)
local Constants = require(ParentParent.Common.Constants)

require(ParentParent.Common.computeStatColumns)

local TEAM_LAYOUT_MULTIPLIER = Constants.TEAM_LAYOUT_MULTIPLIER
local v12 = Signals.createSignal({})

local function EntryView(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), SignalsReact (copy), v12 (copy), Signals (copy), TEAM_LAYOUT_MULTIPLIER (copy), PeopleCell (copy), resolveDisplayName (copy), StatCell (copy), LeaderboardRowShell (copy)
	local player = t1.player
	local leaderboardStore = t1.leaderboardStore
	local v17 = t1.isCurrentUser == true
	local rowHeight = t1.rowHeight
	local v19 = React.useRef(nil)
	local v20 = React.useCallback(function() -- line: 45
		-- upvalues: t1 (copy), v19 (copy), player (copy)
		if t1.onActivated then
			local v29 = if not v19.current then nil else v19.current.AbsolutePosition

			t1.onActivated(player, v29)
		end
	end, {
		player,
		t1.onActivated
	})
	local v21 = leaderboardStore.getPlayerEntry(player, false)

	SignalsReact.useSignalState(if not v21 then v12 else v21.stats.getAllData)

	local v22 = React.useMemo(function() -- line: 59
		-- upvalues: Signals (copy), v21 (copy), t1 (copy), TEAM_LAYOUT_MULTIPLIER (copy)
		return Signals.createComputed(function(p1) -- line: 60
			-- upvalues: v21 (copy), t1 (copy), TEAM_LAYOUT_MULTIPLIER (copy)
			if v21 and t1.teamOrder ~= nil then
				return t1.teamOrder * TEAM_LAYOUT_MULTIPLIER + v21.order(p1)
			end

			return t1.layoutOrder or 0
		end)
	end, {
		v21,
		t1.teamOrder,
		t1.layoutOrder
	})
	local v23 = SignalsReact.useSignalBinding(v22)
	local v24 = t1.statColumns or {}
	local t2 = {
		PeopleCell = React.createElement(PeopleCell, {
			layoutOrder = 1,
			displayName = resolveDisplayName(player),
			player = player
		})
	}

	for i, v in ipairs(v24) do
		local v28 = if not v21 then nil else v21.stats.getData(v.name, false)

		t2[`Stat_{ v.name }`] = React.createElement(StatCell, {
			statName = v.name,
			playerStat = v28,
			statWidth = t1.statWidth,
			rowHeight = rowHeight,
			layoutOrder = i + 1
		})
	end

	return React.createElement(LeaderboardRowShell, {
		showDivider = true,
		rowHeight = rowHeight,
		layoutOrder = v23,
		isHighlighted = v17,
		onActivated = v20,
		rowRef = v19
	}, t2)
end

return React.memo(EntryView)
