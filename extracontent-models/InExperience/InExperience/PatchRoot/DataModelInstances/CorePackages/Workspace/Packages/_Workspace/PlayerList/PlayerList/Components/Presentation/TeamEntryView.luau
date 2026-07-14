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

local GameTextTranslatorContext = require(ParentParent.Common.GameTextTranslatorContext)
local FFlagPlayerListLocalizeGameText = require(ParentParent.Flags.FFlagPlayerListLocalizeGameText)
local ROW_FLEX_TAG = Constants.ROW_FLEX_TAG
local TEAM_LAYOUT_MULTIPLIER = Constants.TEAM_LAYOUT_MULTIPLIER

local function TeamEntryView(t1: {[any]: any}) -- line: 24
	-- upvalues: FFlagPlayerListLocalizeGameText (copy), React (copy), GameTextTranslatorContext (copy), SignalsReact (copy), Signals (copy), TEAM_LAYOUT_MULTIPLIER (copy), View (copy), FoundationText (copy), StatCell (copy), ROW_FLEX_TAG (copy)
	local v17 = if not FFlagPlayerListLocalizeGameText then nil else React.useContext(GameTextTranslatorContext)
	local v18 = SignalsReact.useSignalBinding(t1.name)
	local v19 = if not FFlagPlayerListLocalizeGameText then v18 else React.useMemo(function() -- line: 41
		-- upvalues: v17 (copy), v18 (copy)
		if v17 then
			return (v18:map(v17))
		end

		return v18
	end, {
		v17,
		v18
	})
	local v20 = SignalsReact.useSignalBinding(t1.color)
	local rowHeight = t1.rowHeight
	local v22 = React.useMemo(function() -- line: 48
		-- upvalues: Signals (copy), t1 (copy), TEAM_LAYOUT_MULTIPLIER (copy)
		return Signals.createComputed(function(p1) -- line: 49
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
	local v23 = SignalsReact.useSignalBinding(v22)
	local t2 = {
		NameLabel = React.createElement(View, {
			LayoutOrder = 1,
			tag = "fill size-0-full clip"
		}, {
			Label = React.createElement(FoundationText, {
				tag = "size-full text-label-small text-align-x-left content-emphasis",
				Text = v19
			})
		})
	}

	if t1.statColumns then
		for i, v in ipairs(t1.statColumns) do
			local v27 = if not t1.teamStats then nil else t1.teamStats.getData(v.name, false)

			t2[`TeamStat_{ v.name }`] = React.createElement(StatCell, {
				textTag = "text-label-small content-emphasis",
				statName = v.name,
				playerStat = v27,
				statWidth = t1.statWidth,
				rowHeight = rowHeight,
				layoutOrder = i + 1
			})
		end
	end

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, rowHeight),
		backgroundStyle = v20:map(function(color3: Color3) -- line: 87
			return {
				Transparency = 0.5,
				Color3 = color3
			}
		end),
		LayoutOrder = v23
	}, {
		RowContent = React.createElement(View, {
			tag = `size-full { ROW_FLEX_TAG }`
		}, t2)
	})
end

return React.memo(TeamEntryView)
