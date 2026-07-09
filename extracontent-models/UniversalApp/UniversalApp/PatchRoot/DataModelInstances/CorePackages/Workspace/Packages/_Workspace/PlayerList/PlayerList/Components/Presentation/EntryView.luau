local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences

require(ParentParentParent.LeaderboardStore)

local StatCell = require(ParentParent.Components.Presentation.StatCell)
local PlayerBadge = require(ParentParent.Components.Presentation.PlayerBadge)
local resolveDisplayName = require(ParentParent.Common.resolveDisplayName)
local Constants = require(ParentParent.Common.Constants)

require(ParentParent.Common.computeStatColumns)

local ROW_FLEX_TAG = Constants.ROW_FLEX_TAG
local TEAM_LAYOUT_MULTIPLIER = Constants.TEAM_LAYOUT_MULTIPLIER
local v17 = Signals.createSignal({})

local function EntryView(t1: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), usePreferences (copy), React (copy), SignalsReact (copy), v17 (copy), Signals (copy), TEAM_LAYOUT_MULTIPLIER (copy), View (copy), FoundationText (copy), resolveDisplayName (copy), PlayerBadge (copy), StatCell (copy), Foundation (copy), ROW_FLEX_TAG (copy)
	local player = t1.player
	local leaderboardStore = t1.leaderboardStore
	local v22 = t1.isCurrentUser == true
	local rowHeight = t1.rowHeight
	local v24 = useTokens()
	local v25 = usePreferences()
	local v26 = React.useRef(nil)
	local v27 = React.useCallback(function() -- line: 52
		-- upvalues: t1 (copy), v26 (copy), player (copy)
		if t1.onActivated then
			local v39 = if not v26.current then nil else v26.current.AbsolutePosition

			t1.onActivated(player, v39)
		end
	end, {
		player,
		t1.onActivated
	})
	local v28 = leaderboardStore.getPlayerEntry(player, false)

	SignalsReact.useSignalState(if not v28 then v17 else v28.stats.getAllData)

	local v29 = React.useMemo(function() -- line: 66
		-- upvalues: Signals (copy), v28 (copy), t1 (copy), TEAM_LAYOUT_MULTIPLIER (copy)
		return Signals.createComputed(function(p1) -- line: 67
			-- upvalues: v28 (copy), t1 (copy), TEAM_LAYOUT_MULTIPLIER (copy)
			if v28 and t1.teamOrder ~= nil then
				return t1.teamOrder * TEAM_LAYOUT_MULTIPLIER + v28.order(p1)
			end

			return t1.layoutOrder or 0
		end)
	end, {
		v28,
		t1.teamOrder,
		t1.layoutOrder
	})
	local v30 = SignalsReact.useSignalBinding(v29)
	local v31 = t1.statColumns or {}
	local t2 = {
		PeopleCell = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-left align-y-center fill gap-xsmall size-0-full clip"
		}, {
			NameText = React.createElement(FoundationText, {
				tag = "auto-xy text-body-small text-align-x-left content-default",
				LayoutOrder = 1,
				Text = resolveDisplayName(player)
			}),
			Badge = React.createElement(PlayerBadge, {
				layoutOrder = 2,
				player = player
			})
		})
	}

	for i, v in ipairs(v31) do
		local v35 = if not v28 then nil else v28.stats.getData(v.name, false)

		t2[`Stat_{ v.name }`] = React.createElement(StatCell, {
			statName = v.name,
			playerStat = v35,
			statWidth = t1.statWidth,
			rowHeight = rowHeight,
			layoutOrder = i + 1
		})
	end

	local OverMedia_100 = v24.Color.OverMedia.OverMedia_100
	local v37 = OverMedia_100.Transparency * v25.preferredTransparency
	local t3 = {
		Highlight = if not v22 then nil else React.createElement(View, {
			ZIndex = 0,
			backgroundStyle = {
				Color3 = OverMedia_100.Color3,
				Transparency = v37
			},
			Size = UDim2.fromScale(1, 1)
		}),
		Divider = React.createElement(Foundation.Divider, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0)
		}),
		RowContent = React.createElement(View, {
			tag = `size-full { ROW_FLEX_TAG }`
		}, t2)
	}

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, rowHeight),
		LayoutOrder = v30,
		onActivated = v27,
		ref = v26
	}, t3)
end

return React.memo(EntryView)
