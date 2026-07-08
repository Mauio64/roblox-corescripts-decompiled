local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text

require(ParentParentParent.LeaderboardStore)

local FormatStatString = require(ParentParent.Common.FormatStatString)

local function StatCell(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), Signals (copy), FormatStatString (copy), SignalsReact (copy), View (copy), FoundationText (copy)
	local v12 = React.useMemo(function() -- line: 24
		-- upvalues: Signals (copy), t1 (copy), FormatStatString (copy)
		return Signals.createComputed(function(p1) -- line: 25
			-- upvalues: t1 (copy), FormatStatString (copy)
			if t1.playerStat then
				local v15 = t1.playerStat(p1)

				return FormatStatString(v15)
			end

			return "-"
		end)
	end, { t1.playerStat })
	local v13 = SignalsReact.useSignalBinding(v12)

	return React.createElement(View, {
		tag = "clip",
		Size = UDim2.fromOffset(t1.statWidth, t1.rowHeight),
		LayoutOrder = t1.layoutOrder
	}, {
		StatText = React.createElement(FoundationText, {
			Text = v13,
			tag = `size-full text-align-x-left text-truncate-end { t1.textTag or "text-body-small content-default" }`
		})
	})
end

return React.memo(StatCell)
