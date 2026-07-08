local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text

require(ParentParentParent.LeaderboardStore)

local StatCell = require(ParentParent.Components.Presentation.StatCell)
local Constants = require(ParentParent.Common.Constants)

require(ParentParent.Common.computeStatColumns)

local ROW_FLEX_TAG = Constants.ROW_FLEX_TAG
local TEAM_LAYOUT_MULTIPLIER = Constants.TEAM_LAYOUT_MULTIPLIER

local function TeamEntryView(t1: {[any]: any}) -- line: 22
	-- upvalues: SignalsReact (copy), React (copy), Signals (copy), TEAM_LAYOUT_MULTIPLIER (copy), View (copy), FoundationText (copy), StatCell (copy), ROW_FLEX_TAG (copy)
	local v15 = SignalsReact.useSignalBinding(t1.name)
	local v16 = SignalsReact.useSignalBinding(t1.color)
	local rowHeight = t1.rowHeight
	local v18 = React.useMemo(function() -- line: 36
		-- upvalues: Signals (copy), t1 (copy), TEAM_LAYOUT_MULTIPLIER (copy)
		return Signals.createComputed(function(p1) -- line: 37
			-- upvalues: t1 (copy), TEAM_LAYOUT_MULTIPLIER (copy)
			if t1.order then
				return t1.order(p1) * TEAM_LAYOUT_MULTIPLIER
			end

			return t1.layoutOrder or 0
		end)
	end, {
		t1.order,
		t1.layoutOrder
	})
	local v19 = SignalsReact.useSignalBinding(v18)
	local t2 = {
		NameLabel = React.createElement(View, {
			LayoutOrder = 1,
			tag = "fill size-0-full clip"
		}, {
			Label = React.createElement(FoundationText, {
				tag = "size-full text-label-small text-align-x-left content-emphasis",
				Text = v15
			})
		})
	}

	if t1.statColumns then
		for i, v in ipairs(t1.statColumns) do
			local v23 = if not t1.teamStats then nil else t1.teamStats.getData(v.name, false)

			t2[`TeamStat_{ v.name }`] = React.createElement(StatCell, {
				textTag = "text-label-small content-emphasis",
				statName = v.name,
				playerStat = v23,
				statWidth = t1.statWidth,
				rowHeight = rowHeight,
				layoutOrder = i + 1
			})
		end
	end

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, rowHeight),
		backgroundStyle = v16:map(function(color3: Color3) -- line: 75
			return {
				Transparency = 0.5,
				Color3 = color3
			}
		end),
		LayoutOrder = v19
	}, {
		RowContent = React.createElement(View, {
			tag = `size-full { ROW_FLEX_TAG }`
		}, t2)
	})
end

return React.memo(TeamEntryView)
