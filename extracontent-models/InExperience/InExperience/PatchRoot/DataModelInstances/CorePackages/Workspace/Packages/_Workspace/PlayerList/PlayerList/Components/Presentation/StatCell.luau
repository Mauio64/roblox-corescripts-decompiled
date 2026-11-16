local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Signals = require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)

require(parent2.LeaderboardStore)

local LeaderboardTextCell = require(script.Parent.LeaderboardTextCell)
local FormatStatString = require(parent.Common.FormatStatString)

local function StatCell(props)
	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			if props.playerStat then
				return FormatStatString((props.playerStat(p)))
			end

			return "-"
		end)
	end, { props.playerStat })
	local text = SignalsReact.useSignalBinding(v)

	return React.createElement(LeaderboardTextCell, {
		text = text,
		width = props.statWidth,
		rowHeight = props.rowHeight,
		layoutOrder = props.layoutOrder,
		textTag = `size-full text-align-x-left text-truncate-end {props.textTag or "text-body-small content-default"}`
	})
end

return React.memo(StatCell)
