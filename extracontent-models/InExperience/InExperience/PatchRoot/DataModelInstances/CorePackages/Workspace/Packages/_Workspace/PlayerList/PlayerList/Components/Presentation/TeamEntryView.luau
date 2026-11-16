local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Signals = require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text

require(parent2.LeaderboardStore)

local StatCell = require(parent.Components.Presentation.StatCell)
local Constants = require(parent.Common.Constants)
require(parent.Common.computeStatColumns)

local GameTextTranslatorContext = require(parent.Common.GameTextTranslatorContext)
local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)
local usePreferredTransparencyBinding = require(parent.Hooks.usePreferredTransparencyBinding)

local ROW_FLEX_TAG = Constants.ROW_FLEX_TAG
local TEAM_LAYOUT_MULTIPLIER = Constants.TEAM_LAYOUT_MULTIPLIER

local function TeamEntryView(props)
	local v

	if FFlagPlayerListLocalizeGameText then
		v = React.useContext(GameTextTranslatorContext)
	else
		v = nil
	end

	local v2 = SignalsReact.useSignalBinding(props.name)
	local text

	if FFlagPlayerListLocalizeGameText then
		text = React.useMemo(function()
			if v then
				return (v2:map(v))
			end

			return v2
		end, { v, v2 })
	else
		text = v2
	end

	local color = SignalsReact.useSignalBinding(props.color)
	local pt = usePreferredTransparencyBinding()
	local rowHeight = props.rowHeight

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if props.order then
				return props.order(p) * TEAM_LAYOUT_MULTIPLIER
			end

			return props.layoutOrder or 0
		end)
	end, { props.order, props.layoutOrder })
	local layoutOrder = SignalsReact.useSignalBinding(v3)

	local children = {
		NameLabel = React.createElement(View, { LayoutOrder = 1, tag = "fill size-0-full clip" }, {
			Label = React.createElement(Text, {
				Text = text,
				tag = "size-full text-label-small text-align-x-left content-emphasis"
			})
		})
	}

	if props.statColumns then
		for i, statColumn in ipairs(props.statColumns) do
			local playerStat

			if props.teamStats then
				playerStat = props.teamStats.getData(statColumn.name, false)
			end

			children[`TeamStat_{statColumn.name}`] = React.createElement(StatCell, {
				statName = statColumn.name,
				playerStat = playerStat,
				statWidth = props.statWidth,
				rowHeight = rowHeight,
				layoutOrder = i + 1,
				textTag = "text-label-small content-emphasis"
			})
		end
	end

	local backgroundStyle = React.useMemo(function()
		return React.joinBindings({ color = color, pt = pt }):map(function(p)
			return {
				Color3 = p.color,
				Transparency = 0.5 * p.pt
			}
		end)
	end, { color, pt })

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, rowHeight),
		backgroundStyle = backgroundStyle,
		LayoutOrder = layoutOrder,
		selection = Constants.NOT_SELECTABLE,
		testId = "team-entry-view"
	}, {
		RowContent = React.createElement(View, { tag = `size-full {ROW_FLEX_TAG}` }, children)
	})
end

return React.memo(TeamEntryView)
