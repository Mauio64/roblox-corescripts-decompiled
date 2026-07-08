local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local formatDate = require(VirtualEvents.Common.formatDate)
local getVirtualEventDates = require(VirtualEvents.Common.getVirtualEventDates)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local v9 = utf8.char(8226)

local function EventTimer(t1: {[any]: any}) -- line: 19
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), getVirtualEventDates (copy), StyledTextLabel (copy), formatDate (copy), v9 (copy)
	local v12 = useStyle()
	local v13 = useLocalization({
		cancelled = "Feature.VirtualEvents.EventCancelledText"
	})
	local v14 = t1.virtualEvent.eventStatus == "cancelled"
	local v15 = React.useMemo(function() -- line: 26
		-- upvalues: getVirtualEventDates (copy), t1 (copy)
		return getVirtualEventDates(t1.virtualEvent)
	end, { t1.virtualEvent })

	return React.createElement(StyledTextLabel, {
		text = if not v14 then ("%s %s %s"):format(formatDate(v15.startDate), v9, formatDate(v15.endDate)) else v13.cancelled,
		automaticSize = Enum.AutomaticSize.XY,
		fontStyle = v12.Font.CaptionHeader,
		colorStyle = if not v14 then v12.Theme.TextMuted else v12.Theme.Alert
	})
end

return EventTimer
