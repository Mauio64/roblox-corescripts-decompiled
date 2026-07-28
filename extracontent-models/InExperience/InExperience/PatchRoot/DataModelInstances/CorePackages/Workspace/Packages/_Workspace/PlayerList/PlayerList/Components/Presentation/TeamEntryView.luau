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
local FFlagPlayerListReskinOptimization = require(ParentParent.Flags.FFlagPlayerListReskinOptimization)
local ROW_FLEX_TAG = Constants.ROW_FLEX_TAG
local TEAM_LAYOUT_MULTIPLIER = Constants.TEAM_LAYOUT_MULTIPLIER

local function TeamEntryView(t1: {[any]: any}) -- line: 25
	-- upvalues: FFlagPlayerListLocalizeGameText (copy), React (copy), GameTextTranslatorContext (copy), SignalsReact (copy), Signals (copy), TEAM_LAYOUT_MULTIPLIER (copy), View (copy), FoundationText (copy), StatCell (copy), FFlagPlayerListReskinOptimization (copy), ROW_FLEX_TAG (copy)
	local v18 = if not FFlagPlayerListLocalizeGameText then nil else React.useContext(GameTextTranslatorContext)
	local v19 = SignalsReact.useSignalBinding(t1.name)
	local v20 = if not FFlagPlayerListLocalizeGameText then v19 else React.useMemo(function() -- line: 42
		-- upvalues: v18 (copy), v19 (copy)
		if v18 then
			return (v19:map(v18))
		end

		return v19
	end, {
		v18,
		v19
	})
	local v21 = SignalsReact.useSignalBinding(t1.color)
	local rowHeight = t1.rowHeight
	local v23 = React.useMemo(function() -- line: 49
		-- upvalues: Signals (copy), t1 (copy), TEAM_LAYOUT_MULTIPLIER (copy)
		return Signals.createComputed(function(p1) -- line: 50
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
	local v24 = SignalsReact.useSignalBinding(v23)
	local t2 = {
		NameLabel = React.createElement(View, {
			LayoutOrder = 1,
			tag = "fill size-0-full clip"
		}, {
			Label = React.createElement(FoundationText, {
				tag = "size-full text-label-small text-align-x-left content-emphasis",
				Text = v20
			})
		})
	}

	if t1.statColumns then
		for i, v in ipairs(t1.statColumns) do
			local v28 = if not t1.teamStats then nil else t1.teamStats.getData(v.name, false)

			t2[`TeamStat_{ v.name }`] = React.createElement(StatCell, {
				textTag = "text-label-small content-emphasis",
				statName = v.name,
				playerStat = v28,
				statWidth = t1.statWidth,
				rowHeight = rowHeight,
				layoutOrder = i + 1
			})
		end
	end

	local v29 = if not FFlagPlayerListReskinOptimization then v21:map(function(color3: Color3) -- line: 93
		return {
			Transparency = 0.5,
			Color3 = color3
		}
	end) else React.useMemo(function() -- line: 87
		-- upvalues: v21 (copy)
		return v21:map(function(color3: Color3) -- line: 88
			return {
				Transparency = 0.5,
				Color3 = color3
			}
		end)
	end, { v21 })

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, rowHeight),
		backgroundStyle = v29,
		LayoutOrder = v24
	}, {
		RowContent = React.createElement(View, {
			tag = `size-full { ROW_FLEX_TAG }`
		}, t2)
	})
end

return React.memo(TeamEntryView)
