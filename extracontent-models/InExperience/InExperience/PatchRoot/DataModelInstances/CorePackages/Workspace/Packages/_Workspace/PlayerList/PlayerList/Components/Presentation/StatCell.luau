local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)

require(ParentParentParent.LeaderboardStore)

local LeaderboardTextCell = require(script.Parent.LeaderboardTextCell)
local FormatStatString = require(ParentParent.Common.FormatStatString)

local function StatCell(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), Signals (copy), FormatStatString (copy), SignalsReact (copy), LeaderboardTextCell (copy)
	local v10 = React.useMemo(function() -- line: 22
		-- upvalues: Signals (copy), t1 (copy), FormatStatString (copy)
		return Signals.createComputed(function(p1) -- line: 23
			-- upvalues: t1 (copy), FormatStatString (copy)
			if t1.playerStat then
				local v13 = t1.playerStat(p1)

				return FormatStatString(v13)
			end

			return "-"
		end)
	end, { t1.playerStat })
	local v11 = SignalsReact.useSignalBinding(v10)

	return React.createElement(LeaderboardTextCell, {
		text = v11,
		width = t1.statWidth,
		rowHeight = t1.rowHeight,
		layoutOrder = t1.layoutOrder,
		textTag = `size-full text-align-x-left text-truncate-end { t1.textTag or "text-body-small content-default" }`
	})
end

return React.memo(StatCell)
