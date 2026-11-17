local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Text = Foundation.Text

local LeaderboardTextCell = require(script.Parent.LeaderboardTextCell)
local Signals = require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)

require(parent2.LeaderboardStore)

local FormatStatString = require(parent.Common.FormatStatString)
local FFlagPlayerListContrastingTeamText = require(parent.Flags.FFlagPlayerListContrastingTeamText)

local function StatCell(props)
	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			if not props.playerStat then
				return "-"
			end

			return FormatStatString((props.playerStat(p)))
		end)
	end, { props.playerStat })
	local text = SignalsReact.useSignalBinding(v)

	if FFlagPlayerListContrastingTeamText then
		return React.createElement(Text, {
			Text = text,
			Size = UDim2.fromOffset(props.statWidth, props.rowHeight),
			LayoutOrder = props.layoutOrder,
			tag = "text-align-x-left text-truncate-end clip",
			fontStyle = props.fontStyle,
			textStyle = props.textStyle
		})
	end

	return React.createElement(LeaderboardTextCell, {
		text = text,
		width = props.statWidth,
		rowHeight = props.rowHeight,
		layoutOrder = props.layoutOrder,
		textTag = `size-full text-align-x-left text-truncate-end {props.textTag or "text-body-small content-default"}`
	})
end

return React.memo(StatCell)
